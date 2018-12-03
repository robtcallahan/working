#!/bin/bash

vm="bld-rhel67-x86_64-evo-24.eng.idirect.net"
ip="172.20.2.202"
#image_dir="/var/lib/libvirt/images"
image_dir="/srv/kvm-images"
ks_location=http://kickstart.eng.idirect.net/ks/DevOps/rhel-ks-basic.cfg
#iso_location="/var/lib/libvirt/images/iso/RedHat/6/6.7/rhel-server-6.7-x86_64-dvd.iso"
iso_location="/srv/kvm-images/iso/RedHat/6/6.7/rhel-server-6.7-x86_64-dvd.iso"

rval=0
qemu-img create -f qcow2 -o preallocation=full,size=101G ${image_dir}/${vm}

if [ ${?} == 0 ]
then
    rval=0
else
    rval=1
fi

if [ ${rval} == 0 ]
then
    chown qemu:qemu ${image_dir}/${vm}
    rval=${?}
fi

if [ ${rval} == 0 ]
then
virt-install --debug \
             --name ${vm} \
             --ram 16384 \
             --graphics vnc \
             --disk path=${image_dir}/${vm} \
             --network network:engineering,model=e1000 \
             --network network:crypto,model=e1000 \
             --os-type=linux \
             --os-variant=rhel6 \
             --autostart \
             --noautoconsole \
             --accelerate \
             --boot cdrom \
             --vcpus=8 \
             --location ${iso_location} -x \
                       "ks=${ks_location} \
                       ksdevice=eth0 \
                       ip=${ip} \
                       netmask=255.255.0.0 \
                       dns=172.20.2.99,172.20.2.98 \
                       gateway=172.20.255.254 \
                       ip=${ip}::172.20.255.254:255.255.0.0:${vm}:eth0:none"
fi
