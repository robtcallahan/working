#!/bin/bash

hypervisors="sst-kvm01 sst-kvm02 sst-kvm04 sst-kvm05 sst-kvm06 sst-kvm07 sst-kvm08 kvm-dev-01"


for hypervisor in $hypervisors
do
	echo "Contacting $hypervisor"
	#ssh $hypervisor "df -lh  | grep -v opt | grep -v tmpfs | grep -v udev | grep -v ENG"
	ssh $hypervisor "sudo virsh list --all"
	#ssh $hypervisor "sudo free -g | grep Mem"
	#ssh $hypervisor "cat /proc/cpuinfo | grep processor | tail -1"
	echo "Done with $hypervisor"
done
