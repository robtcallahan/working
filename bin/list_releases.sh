#!/bin/bash

#aws s3 ls s3://idirect-releases --profile idirect-enterprise | sed -e 's/^\s\+//' | sed -e 's/\/$//'

profile="--profile idirect-enterprise"
s3bucket="idirect-releases"
domain="http://d8lkzio2al7h7.cloudfront.net"

aws s3 ls s3://$s3bucket --recursive $profile | awk '{$1="";$2="";$3=""; print $0}' | sed -e 's/^\s\+//' | while read -r file
do
  if [[ $file =~ /$ ]];
  then
    #echo $(echo $file | cut -d/ -f1)
    continue
  else
    #echo "    " $(echo $file | cut -d/ -f2)
    echo "${file},${domain}/$(echo ${file} | sed -e 's/ /%20/g')"
  fi
  #echo $file,http://d8lkzio2al7h7.cloudfront.net/$file
  #aws s3 cp "s3://$s3bucket/$file" "$file" $profile
done
