#!/bin/bash

profile="--profile idirect-enterprise"
releasesdir="/releases"
tacdir=${releasesdir}/tac
release=""
file="checkcksh.gz"

s3_artifacts=$(aws s3 ls "s3://idirect-releases" --recursive --profile idirect-enterprise | awk '{$1="";$2="";$3=""; print $0}' | sed -e 's/^\s\+//' | sed 's/\/$//')
echo "${s3_artifacts}" | while read s3_artifact; do
  if [[ $(echo "${s3_artifact}" | sed -n '/SatHaul/p') ]]; then
    continue
  fi

  test_for_release=$(echo "${s3_artifact}" | grep '/')
  if [[ "${test_for_release}" == "" ]]; then
    release="${s3_artifact}"
    echo -e "\n${s3_artifact}"
    aws s3 cp "${tacdir}/${file}" "s3://idirect-releases/${release}/${file}" ${profile} >/dev/null 2>&1
  fi
done
