#!/bin/bash

readonly CURRENT_VERSION="1.23.0"

httpSingleUpload()
{
  response=$(curl --progress-bar --upload-file "$file" "https://transfer.sh/$file_name")# || { echo "Failure!"; return 1;} 
 #response=$(curl -A curl --upload-file "$1" "https://transfer.sh/$2") || { echo "Failure!"; return 1;}
}

printUploadResponse()
{
#fileID=$(echo "$response" | cut -d "/" -f 4)
  cat <<EOF
Transfer File URL: $response
EOF
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
  echo "funcDomw"
}
if [ "$1" == "-h" ]; then
  echo "Description: Bash tool to transfer files from the command line. 
    Usage: 
    -d  ...
    -h  Show the help ... 
    -v  Get the tool version 
    Examples: 
    <Write a couple of examples, how to use your tool>"
elif [ "$1" == "-v" ]; then
  echo "$CURRENT_VERSION"
elif [[ "$#" -eq 1 ]]; then
	echo "$1"
  file_upload=$1
  singleUpload "$file_upload" || exit 1
  printUploadResponse
elif [[ "$#" -ne 1 ]]; then
  for ARG in "$@"; do
    file_upload=$ARG
    singleUpload "$ARG" || exit 1
    printUploadResponse
  done
fi
