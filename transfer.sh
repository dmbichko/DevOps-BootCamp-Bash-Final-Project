#!/bin/bash

readonly CURRENT_VERSION="1.23.0"

httpSingleUpload()
{
  response=$(curl --progress-bar --upload-file "$file" "https://transfer.sh/$file_name") 
#response=$(curl -A curl --upload-file "$1" "https://transfer.sh/$2") || { echo "Failure!"; return 1;}
}

printUploadResponse()
{
#fileID=$(echo "$response" | cut -d "/" -f 4)
  printf "Transfer File URL: %s\n" "$response"
}

singleUpload()
{
  file="$file_upload"
  file_name=$(basename "$file")
  echo "Uploading " "$file_name"
  httpSingleUpload "$file $file_name"
}
singleDowload()
{
  echo "Downloading " "$file_download"
  (curl --progress-bar https://transfer.sh/"$id_download"/"$file_download" -o "$dir_download"/"$file_download") || { echo "Failure!"; return 1;}
  #(curl --progress-bar https://transfer.sh/"$fileID"/"$file_download" -o "$dir_download"/"$file_download") || { echo "Failure!"; return 1;}
}
printDownloadResponse()
{
  #if [[ $result_download -eq 0 ]]; then 
    printf "Success!\n"
  #fi
}
read -r -a arg_array <<< "$@"

if [ $# -eq 0 ];then printf "No arguments specified.\n"
  printf "Usage: transfer <file|directory> | transfer <file_name> \n"; 
  exit 1;
fi
flag=${arg_array[0]}
count_arg=${#arg_array[@]}
#if [[ "${r[$index]}" -eq "$n" ]]; then
if [[ "$count_arg" == 1 ]]; then
  if [[ "$1" == "-h" ]]; then
    echo "Description: Bash tool to transfer files from the command line. 
      Usage: 
      -d  ...
      -h  Show the help ... 
      -v  Get the tool version 
      Examples: 
      <Write a couple of examples, how to use your tool>"
  elif [[ "$1" == "-v" ]]; then  
    echo "$CURRENT_VERSION"
  else
    file_upload=${arg_array[0]}
    singleUpload "$file_upload" || exit 1
    printUploadResponse
  fi
elif [[ "$count_arg" == 4 ]]; then
  if [[ "$flag" == "-d" ]]; then
    id_download=${arg_array[2]}
    dir_download=${arg_array[1]}
    file_download=${arg_array[3]}
    singleDowload "$id_download" "$dir_download" "$file_download" || exit 1
    printDownloadResponse
  fi
elif [[ "$count_arg" -gt 1 ]]; then
  for ARG in "${arg_array[@]}"; do
    file_upload=$ARG
    singleUpload "$ARG" || exit 1
    printUploadResponse
  done
fi
