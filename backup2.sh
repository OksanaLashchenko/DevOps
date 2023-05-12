# Set the source directory and backup directory paths
src_dir="/home/oksanalashchenko/source_backup"
backup_dir="/home/oksanalashchenko/backup"

# Create the backup directory if it doesn't exist
if [ ! -d $backup_dir ]; then
    mkdir $backup_dir
fi

# Loop through all files in the source directory
for file in $src_dir/*; do

    # Check if the file has a .dat extension
    if [[ $file == *.dat ]]; then
        echo "Skipping $file"
    else
        # Copy the file to the backup directory
        cp $file $backup_dir
        echo "Added $file to backup"
    fi
done