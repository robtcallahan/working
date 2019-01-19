#!/bin/bash

aws ec2 run-instances \
	--output table \
	--profile idirect-eng \
	--region us-east-1 \
	--image-id ami-f5c6ce8a \
	--count 1 \
	--instance-type m1.medium \
	--key-name idirect-eng_rsa \
	--subnet-id subnet-16cee539 \
	--security-group-ids sg-1cc52155 sg-cea604b8 \
	--tag-specifications 'ResourceType=instance,Tags=[{Key="Name",Value="rob-test"}]'
