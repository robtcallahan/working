#!/bin/bash

profile="--profile idirect-enterprise"
posted="To be posted"
#topdir=/dump/Jessica\ Software\ Archive\ 1\ as\ of\ 8_17_2018
topdir=/dump/Jessica\ Software\ Archive\ 2\ as\ of\ 8_17_2018

cd "$topdir"
cat "$topdir/releases.txt" | while read -r reldir; do
  echo $reldir
  aws s3api put-object --bucket idirect-releases --key "$reldir/" $profile
  cd "$reldir"

  cd "$(find . -name To\ be\ posted)" || exit 1

  ls -f . | while read -r file; do
    if [[ $file == "." || $file == ".." ]]; then
      continue
    fi
    echo $file
    aws s3 cp "$file" "s3://idirect-releases/$reldir/$file" $profile
  done
  echo ""
  cd "$topdir"
done
