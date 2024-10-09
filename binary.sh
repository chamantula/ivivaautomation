#!/bin/bash

<< Harish
Author: Harish
Version: 1.3
Harish
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

check_filename() {
  local lower_name="${1,,}"  # Convert to lowercase
  grep -iq "^$lower_name\.tar\.gz$" list_lower.txt
}

check_Binary() {
	ls > files.txt
	echo $file
	files="${file%.tar.gz}"
	files=$(grep -i "$files" files.txt)
	echo $files
}
compress_Binary() {
    if check_Binary "$file"; then
            if [ -z "$files" ]; then
                    echo "No Binary Exits with name $files"
            else
                echo -e "${RED}Compressing the Exiting Binaries${NC}"    
                tar -czvf "Backup/${files}_${today}.tar.gz" $files
                if [ $? -eq 0 ]; then
                   echo -e "${GREEN}Successfully Compressed $files${NC}"
                else
                   echo -e "${RED}Failed to compress $files${NC}"
                   exit
                fi
            fi
    fi


}
today=$(date +"%Y-%m-%d")  
# Prompt user for directory path to create folders
#read -p "Enter the directory path to create folders (e.g., /var/data/binaries): " dir_path
dir_path=/var/data/iviva
mkdir -p "$dir_path"

# Check if directory creation was successful
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Directories created successfully: $dir_path${NC}"
else
  echo -e "${RED}Failed to create directories: $dir_path${NC}"
  exit 1
fi

# Change directory to user specified path
cd "$dir_path" || exit
mkdir -p Backup
sudo mkdir -p /var/data/iviva/apps

# URL and credentials
#read -p "Enter the release version: " v4
#read -p "Enter the release verison : " version
v4=v4
version=29b29536a5114d54e5303d07dec5b1fc97b17874
url="http://releases.ivivacloud.com/$v4/$version/"
username="eutech"
password="eutech@123"

# Fetch HTML content from the URL
html_content=$(curl -u "$username:$password" -s "${url}index.html")

# Check if curl command succeeded
if [ $? -ne 0 ]; then
  echo -e "${RED}Failed to retrieve the page.${NC}"
  exit 1
fi

# Extract .tar.gz filenames from HTML content
echo "$html_content" | grep -oP "href='[^']+\.tar\.gz'" | sed -E "s/href='([^']+)'/\1/" | grep -v 'win-' > list.txt

# Create a lowercased version of list.txt for case-insensitive comparisons
awk '{print tolower($0)}' list.txt > list_lower.txt

echo -e "${CYAN}Available .tar.gz files (excluding '-win-'):${NC}"
cat list.txt

# Prompt user to download all files or select manually
#read -p "Press Enter to download all files? or NO/no to select manually: " download_all
download_all=""
if [[ "$download_all" == "yes" || "$download_all" == "" ]]; then
  # Download all files listed in list.txt
  while IFS= read -r file; do
    compress_Binary    

    echo -e "${CYAN}Downloading $file...${NC}"
    curl -u "$username:$password" -O "$url$file"
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully downloaded $file${NC}"
      echo -e "${CYAN} ExTractingDownloaded files${NC}"
      tar -xvf "$file"
      if [ $? -eq 0 ]; then
          echo -e "${GREEN}Successfully extracted $file${NC}"
          rm "$file"  # Remove the downloaded .tar.gz file after extraction
        else
          echo -e "${RED}Failed to extract $file${NC}"
      fi
    else
      echo -e "${RED}Failed to download $file${NC}"
    fi
  done < list.txt
else
  # Prompt user to enter filenames manually
  read -p "Enter the names of the files to download (separated by spaces, excluding '.tar.gz'): " -a filenames

  for name in "${filenames[@]}"; do
    # Check if the filename (case-insensitive) exists in list_lower.txt
    if check_filename "$name"; then
      # Find the exact filename in original list.txt (case-sensitive)
      file=$(grep -i "^$name\.tar\.gz$" list.txt)
      echo $file
      compress_Binary 
      
      
      
      
      echo -e "${CYAN}Downloading $file...${NC}"
      curl -u "$username:$password" -O "$url$file"

      # Check if download was successful
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}Successfully downloaded $file${NC}"

        # Extract the downloaded file
        tar -xvf "$file"

        # Check if extraction was successful
        if [ $? -eq 0 ]; then
          echo -e "${GREEN}Successfully extracted $file${NC}"
          rm "$file"  # Remove the downloaded .tar.gz file after extraction
        else
          echo -e "${RED}Failed to extract $file${NC}"
        fi
      else
        echo -e "${RED}Failed to download $file${NC}"
      fi
    else
      echo -e "${RED}File $name not found in directory.${NC}"
    fi
  done
fi

# Clean up: remove temporary list files
rm list.txt
rm list_lower.txt
rm files.txt
exit 0


