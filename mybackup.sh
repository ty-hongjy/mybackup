#vi mysql_full_bak.sh
#!/bin/sh
#cd  `dirname $0`

# This is mysql mysqlfullbak scripts
#2009-08-20
#badboy
#20190315 modified by hongjy

cd "$( dirname "${BASH_SOURCE[0]}" )"


#read config file 
while read line;do  
    eval "$line"  
done < mybackup.cnf  
echo $dateserver
echo $databases
echo $user
echo $port
echo $log_file
echo $delete_backup_dir

source mybackup.cnf
echo $dateserver
echo $databases
echo $user
echo $port
echo $log_file
echo $delete_backup_dir

touch $log_file

dateserver=192.168.10.57
databases="gx"
user=root
passwd=111
port=3306

databak_dir=`date +%Y%m%d`   #备份的目录
mkdir $databak_dir
tarfile=gz-$databak_dir.tar.gz

#exit 

#备份数据
for database in $databases
{
    dumpFile=${database}-$databak_dir.sql
    echo start backup $dumpFile at:`date +%T` >> $log_file
    options="-u$user -p$passwd -P$port -h$dateserver --extended-insert=false --triggers=false $database"
    mysqldump $options > $databak_dir/$dumpFile  #导出数据文件

if [[ $? == 0 ]]; then #备份成功    
    echo "BackupFileName:$dumpFile" >> $log_file
    echo "DataBase Backup Success" >> $log_file
else
    echo "数据库:$database备份失败 " >> $eMailFile
fi
}

echo start tar $tarfile at:`date +%T` >> $log_file
tar -cvzf $tarfile $databak_dir
echo end tar $tarfile at:`date +%T` >> $log_file

if [ $delete_backup_dir = "yes" ]; then
#if test $delete_backup_dir = "yes"; then
	echo start rm $databak_dir at:`date +%T`  >> $log_file
	rm $databak_dir -rf
	echo end rm $databak_dir at:`date +%T`  >> $log_file
fi

echo '---------------------------------------'  >> $log_file


