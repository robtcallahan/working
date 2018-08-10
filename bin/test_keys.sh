#!/bin/bash

hosts_file=$1
if [[ ${hosts_file} == "" ]];
then
    echo "Usage: $0 <hosts_file>"
    exit 1
fi

num_hosts=$(cat ${hosts_file} | wc -l)
hosts=$(cat ${hosts_file})

i=1
for h in ${hosts};
do
    printf "[%2d of %2d] %-32s: " ${i} ${num_hosts} ${h}
    ssh $h echo "OK";
    let i=i+1
done
