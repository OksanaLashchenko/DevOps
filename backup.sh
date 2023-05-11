# Set variables
backup_dir="/home/oksanalashchenko/backup"
backup_date=$(date +"%Y-%m-%d")
backup_file="$backup_dir/backup_$backup_date.tar.gz"
files_to_backup="/home/oksanalashchenko/to_backup"

# Create backup archive
tar -cvpf $backup_file $files_to_backup

