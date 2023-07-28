#find and replace API server IP
find /path/to/directory -type f -exec sed -i 's/\b103\.5\.6\.2\b/211.0.128.110/g' {} +


#copy with key as password
scp -i /path/to/private_key /path/to/local_file username@remote_host:/path/to/destination_directory

