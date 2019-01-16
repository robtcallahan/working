#!/bin/bash

release="$1"
if [[ "${release}" == "" ]]; then
	echo "Usage: $0 <release>"
	exit 1
fi

profile="--profile idirect-enterprise"
find . | while read file; do
	if [[ "$file" == "." ]]; then
		continue
	fi
	f=$(echo "${file}" | cut -d'/' -f2)
	aws s3 cp "$f" "s3://idirect-releases/$release/$f" $profile;
done
