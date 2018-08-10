#!/bin/bash

echo -n "Copying id_dsa..."
cp jenkins.id_dsa ~/.ssh/id_dsa
echo -n ", id_dsa.pub..."
cp jenkins.id_dsa.pub ~/.ssh/id_dsa.pub
echo -n ", id_rsa..."
cp jenkins.id_rsa ~/.ssh/id_rsa
echo -n ", id_rsa.pub..."
cp jenkins.id_rsa.pub ~/.ssh/id_rsa.pub
echo ""
