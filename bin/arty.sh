#!/bin/bash

curl --user rcallahan:AKCp5bBNQKvjb64sU69LD1svhSgLd7zAaX9ntjX2sJDGfU74htFdaR2yiBFGmPCrfghUFswnz \
    --upload-file alfred.json \
    "http://arm-dev-01.eng.idirect.net:8081/artifactory/deliverables/pulse/2.5.1/gcow2/alfred.json"

#curl --user rcallahan:AKCp5bBNQKvjb64sU69LD1svhSgLd7zAaX9ntjX2sJDGfU74htFdaR2yiBFGmPCrfghUFswnz \
#    -O "http://arm-dev-01.eng.idirect.net:8081/artifactory/downloads/kvm_images/alfred.json"
