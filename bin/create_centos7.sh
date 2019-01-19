#!/bin/bash

# CentOS Linux 7 x86_64 HVM EBS ENA 1805_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-77ec9308.4 (ami-9887c6e7)

aws ec2 run-instances \
	--output table \
	--profile idirect-eng \
	--region us-east-1 \
	--image-id ami-9887c6e7 \
	--count 1 \
	--instance-type t2.micro \
	--key-name idirect-eng_rsa \
	--subnet-id subnet-16cee539 \
	--security-group-ids sg-cea604b8 \
	--tag-specifications 'ResourceType=instance,Tags=[{Key="Name",Value="rob-dev"}]'
