#!/bin/bash

hosts_file=$1
command=$2
if [[ ${hosts_file} == "" || ${command} == "" ]];
then
    echo "Usage: run_command.sh <hosts_file> <command>"
    exit 1
fi

num_hosts=$(cat ${hosts_file} | wc -l)
hosts=$(cat ${hosts_file})

i=1
for h in ${hosts};
do
    printf "[%2d of %2d] %-32s...\n" ${i} ${num_hosts} ${h}
    ssh $h "${command}";
    let i=i+1
done
