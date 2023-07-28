#find and replace API server IP
find /path/to/directory -type f -exec sed -i 's/\b192\.168\.2\.46\b/3.82.20.204/g' {} +


find /path/to/directory -type f -exec sed -E -i 's/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/192.168.70.250/g' {} +

# Explanation:

# find /path/to/directory -type f: This part of the command will find all files in the specified directory and its subdirectories.
# -exec: This option allows us to execute a command on each found file.
# sed -E -i: This invokes the sed command with the following options:
# -E: Enables extended regular expressions so we can use more advanced patterns.
# -i: Modifies the files in place (i.e., performs the substitution directly on the files).
# The sed expression 's/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/192.168.70.250/g' is used to match IP addresses and replace them with 192.168.70.250. Let's break it down:

# \b: This is a word boundary anchor, ensuring that we match complete IP addresses, not parts of them.
# ([0-9]{1,3}\.){3}: This part matches three occurrences of 1 to 3 digits followed by a dot. This covers the first three segments of an IP address (e.g., 192.168.70.).
# [0-9]{1,3}: This matches the fourth segment of an IP address (e.g., 250).
# /g: This flag stands for "global," and it ensures that all occurrences of the IP address in a line are replaced, not just the first one.
# This script will replace any IP address pattern in the specified files with 192.168.70.250. Be cautious when using the -i option with sed since it modifies files in
#  place and there is no undo option. It's always a good idea to make a backup of your files before running such commands.




#copy with key as password
scp -i /path/to/private_key /path/to/local_file username@remote_host:/path/to/destination_directory

