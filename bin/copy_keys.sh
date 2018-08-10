#!/bin/bash

hostsfile=$1
if [[ ${hostsfile} == "" ]];
then
    echo "Usage: $0 <hosts_file>"
    exit 1
fi

keysfile="jenkins-keys.pub"

num_hosts=$(grep -v '#' ${hostsfile} | wc -l)
hosts=$(grep -v '#' ${hostsfile})
i=1
for host in ${hosts}
do
    printf "[%2d of %2d] %-32s" ${i} ${num_hosts} ${host}

    # determine the home dir of the jenkins user on the worker node
    home=$(ssh $host "egrep -e '^jenkins:' /etc/passwd" | awk -F':' '{print $6}')

    sshdir="${home}/.ssh"
    oldsshdir="${home}/.ssh-old"
    tmpfile="${sshdir}/tmpfile"
    authfile="${sshdir}/authorized_keys"

    # if ~/.ssh-old directory doesn't exist, copy the .ssh files to .ssh-old to preserve them
    ssh $host "if [[ ! -d ${oldsshdir} ]]; then mkdir ${oldsshdir}; cp ${sshdir}/* ${oldsshdir}; fi"
    echo -n "."

    # copy the public rsa and dsa keys to a temp file on worker node
    scp -q ${keysfile} $host:${tmpfile}
    echo -n "."
    # prepend the new keys to the authorized_keys file
    ssh $host "cat ${authfile} >> ${tmpfile}; mv ${tmpfile} ${authfile}"
    echo -n "."

    # copy the public and private rsa and dsa keys to the remote .ssh directory
    ssh -q ${host} "sudo chown -R jenkins.jenkins ${sshdir}; chmod 700 ${sshdir}; if [[ -f ${sshdir}/id_dsa ]]; then chmod 600 ${sshdir}/id_dsa; chmod 644 ${sshdir}/id_*.pub; fi; if [[ -f ${sshdir}/id_rsa ]]; then chmod 600 ${sshdir}/id_rsa; chmod 644 ${sshdir}/id_*.pub; fi; chmod 644 ${sshdir}/authorized_keys"
    echo -n "."
    ssh $host "if [[ ! -d ${oldsshdir} ]]; then mkdir ${oldsshdir}; cp ${sshdir}/* ${oldsshdir}; fi"
    echo -n "."

    scp -q jenkins.id_rsa ${host}:${sshdir}/id_rsa
    echo -n "."
    scp -q jenkins.id_rsa.pub ${host}:${sshdir}/id_rsa.pub
    echo -n "."
    scp -q jenkins.id_dsa ${host}:${sshdir}/id_dsa
    echo -n "."
    scp -q jenkins.id_dsa.pub ${host}:${sshdir}/id_dsa.pub
    echo -n "."

    ssh -q ${host} "chmod 700 ${sshdir}; chmod 600 ${sshdir}/id_dsa ${sshdir}/id_rsa; chmod 644 ${sshdir}/id_*.pub; chmod 644 ${sshdir}/authorized_keys"
    echo -n "."

    ssh ${host} echo "OK";
    let i=i+1
done
