#!/bin/bash

readonly CURRENT_VERSION="1.23.0"

httpSingleUpload()
{
  response=$(curl --progress-bar --upload-file "$file" "https://transfer.sh/$file_name")# || { echo "Failure!"; return 1;} 
#response=$(curl -A curl --upload-file "$1" "https://transfer.sh/$2") || { echo "Failure!"; return 1;}
}

printUploadResponse()
{
fileID=$(echo "$response" | cut -d "/" -f 4)
  printf '%s' "Transfer File URL: ""$response""\n"
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

  (curl --progress-bar https://transfer.sh/"$fileID"/"$file_download" -o "$dir_download"/"$file_download") || { echo "Failure!"; return 1;}
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
if [[ "$flag" == "-h" && "$count_arg" == 1 ]]; then
  echo "Description: Bash tool to transfer files from the command line. 
    Usage: 
    -d  ...
    -h  Show the help ... 
    -v  Get the tool version 
    Examples: 
    <Write a couple of examples, how to use your tool>"
elif [[ "$flag" == "-v" && "$count_arg" == 1 ]]; then  
  echo "$CURRENT_VERSION"
elif [[ "$flag" == "-d" && "$count_arg" -eq 4 ]]; then
  id_download=${arg_array[2]}
  dir_download=${arg_array[1]}
  file_download=${arg_array[3]}
  singleDowload "$id_download" "$dir_download" "$file_download" || exit 1
  printDownloadResponse
elif [[ ${#arg_array[*]} -eq 1 ]]; then
  
  file_upload=${arg_array[0]}
  singleUpload "$file_upload" || exit 1
  printUploadResponse
elif [[ ${#arg_array[*]} -gt 1 ]]; then
  for ARG in "${arg_array[@]}"; do
    file_upload=$ARG
    singleUpload "$ARG" || exit 1
    printUploadResponse
  done
fi
