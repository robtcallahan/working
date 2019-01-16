#!/bin/bash

debug=0
do_this_many=9
file_num=0

profile="--profile idirect-enterprise"
posted="To be posted"
releasesdir="/releases"
workingdir="/home/rcallahan/workspace/working"
rundir=${workingdir}/run
s3dir=${releasesdir}/s3
tacdir=${releasesdir}/tac
s3_artifacts_file="${rundir}/s3_artifacts.txt"
check_file="checkcksh.gz"
skip_releases="${rundir}/skip_releases.txt"
cookies_file=${rundir}/cookies.txt
releases_file="${rundir}/releases.txt"
errors_file="${rundir}/errors.txt"
tac_url="http://tac.idirect.net/sitecore/content/iDirectTac/Login/Home/Software-Releases/iDX"
tac_domain="http://tac.idirect.net"
pup="/home/rcallahan/workspace/working/bin/pup"

echo /dev/null > ${errors_file}

pass=0
release=""
last_release=""
s3_artifacts=$(aws s3 ls "s3://idirect-releases" --recursive --profile idirect-enterprise | awk '{$1="";$2="";$3=""; print $0}' | sed -e 's/^\s\+//' | sed 's/\/$//')
echo "${s3_artifacts}" > run/s3_artifacts.txt
echo "${s3_artifacts}" | while read s3_artifact; do
  if [[ $(echo "${s3_artifact}" | sed -n '/SatHaul/p') ]]; then
    if [[ ${debug} == 1 ]]; then echo "SatHaul...continuing"; fi
    continue
  fi

  test_for_release=$(echo "${s3_artifact}" | grep '/')
  #echo "test_for_release=${test_for_release}"
  if [[ ${debug} == 1 ]]; then echo "test_for_release=${test_for_release}"; fi
  if [[ "${test_for_release}" == "" ]]; then
    let pass=$pass+1
    if [[ $pass > $do_this_many ]]; then
      exit 0
    fi

    release="${s3_artifact}"
    if [[ ${debug} == 1 ]]; then echo "release=${s3_artifact}"; fi
    echo -e "\n${s3_artifact}"
    continue
  fi

  echo -n "${s3_artifact}..."
  let file_num=file_num+1

  if [[ $(grep -v "#" ${skip_releases} | grep "${release}$") != "" ]]; then
    #echo -n "return=$?"
    echo "skipping"
    continue
  fi

  s3_artifact=$(echo "${s3_artifact}" | cut -d/ -f2)
  if [[ ${debug} == 1 ]]; then echo "s3_artifact=${s3_artifact}"; fi

  version_num=$(echo "${s3_artifact}" | sed 's/.* \([0-9\.].*[0-9]\)\..*/\1/')
  if [[ ${debug} == 1 ]]; then echo "version_num=${version_num}"; fi

  #echo ""
  # parse the release and convert to URL
  major_version=$(echo ${release} | sed 's/iDX \([0-9]\)\..*/\1/')
  #echo "major_version=${major_version}"
  release_url=$(echo ${release} | sed  's/ /-/g' | sed 's/\./_/g' | sed 's/Restricted/RESTRICTED/')
  release_url2=$(echo ${release_url} | sed 's/-RESTRICTED//')
  if [[ ${debug} == 1 ]]; then echo "release_url=${release_url}"; fi

  #echo ""
  tac_release_url="${tac_url}/iDX-${major_version}/${release_url}/${release_url2}-Software-and-Documentation-Downloads.aspx"
  #echo "tac_release_url=${tac_release_url}"
  if [[ "${release}" != "${last_release}" ]]; then
    release_page=$(curl -s -b ${cookies_file} "${tac_release_url}")
    html_releases=$(echo "${release_page}" | $pup 'a' | egrep 'Software[ -]Releases|edgecastcdn' |grep -v " Software Releases" | cut -d\" -f2)
    if [[ "${html_releases}" == "" ]]; then
      tac_release_url=$(echo "${tac_release_url}" | sed 's/Software-and-Documentation-Downloads/Documentation-Downloads/')
      #echo "tac_release_url=${tac_release_url}"
      release_page=$(curl -s -b ${cookies_file} "${tac_release_url}")
      html_releases=$(echo "${release_page}" | $pup 'a' | egrep 'Software[ -]Releases|edgecastcdn' |grep -v " Software[ -]Releases" | cut -d\" -f2)
      if [[ "${html_releases}" == "" ]]; then
        tac_release_url=$(echo "${tac_release_url}" | sed 's/Documentation-Downloads/Software-and-Documentation-Downloads_RESTRICTED/')
        #echo "tac_release_url=${tac_release_url}"
        release_page=$(curl -s -b ${cookies_file} "${tac_release_url}")
        html_releases=$(echo "${release_page}" | $pup 'a' | egrep 'Software[ -]Releases|edgecastcdn' |grep -v " Software[ -]Releases" | cut -d\" -f2)
        if [[ "${html_releases}" == "" ]]; then
          tac_release_url=$(echo "${tac_release_url}" | sed 's/Software-and-Documentation-Downloads_RESTRICTED/Software-and-Documentation_RESTRICTED/')
          #echo "tac_release_url=${tac_release_url}"
          release_page=$(curl -s -b ${cookies_file} "${tac_release_url}")
          html_releases=$(echo "${release_page}" | $pup 'a' | egrep 'Software[ -]Releases|edgecastcdn' |grep -v " Software[ -]Releases" | cut -d\" -f2)
          if [[ "${html_releases}" == "" ]]; then
            tac_release_url=$(echo "${tac_release_url}" | sed 's/Software-and-Documentation_RESTRICTED/Software-and-Documentation/')
            #echo "tac_release_url=${tac_release_url}"
            release_page=$(curl -s -b ${cookies_file} "${tac_release_url}")
            html_releases=$(echo "${release_page}" | $pup 'a' | egrep 'Software[ -]Releases|edgecastcdn' |grep -v " Software[ -]Releases" | cut -d\" -f2)
            if [[ "${html_releases}" == "" ]]; then
              tac_release_url=$(echo "${tac_release_url}" | sed 's/-RESTRICTED/_RESTRICTED/')
              #echo "tac_release_url=${tac_release_url}"
              release_page=$(curl -s -b ${cookies_file} "${tac_release_url}")
              html_releases=$(echo "${release_page}" | $pup 'a' | egrep 'Software[ -]Releases|edgecastcdn' |grep -v " Software[ -]Releases" | cut -d\" -f2)
              if [[ "${html_releases}" == "" ]]; then
                tac_release_url=$(echo "${tac_release_url}" | sed 's/Software-and-Documentation/Software-and-Documentation_RESTRICTED/')
                #echo "tac_release_url=${tac_release_url}"
                release_page=$(curl -s -b ${cookies_file} "${tac_release_url}")
                html_releases=$(echo "${release_page}" | $pup 'a' | egrep 'Software[ -]Releases|edgecastcdn' |grep -v " Software[ -]Releases" | cut -d\" -f2)
                if [[ "${html_releases}" == "" ]]; then
                  echo "Could not find the release page"
                  exit 1
                fi
              fi
            fi
          fi
        fi
      fi
    fi

    #echo "release_page=${release_page}"
    #echo "${release_page}" > run/release_page.html

    html_releases=$(echo "${release_page}" | $pup 'a' |  egrep 'Software[ -]Releases|edgecastcdn' | egrep -e "${major_version}|edgecastcdn" | grep -v 'id=' | cut -d\" -f2)
  fi
  last_release=$release

  html_anchor=$(echo "${html_releases}" | grep "${s3_artifact}")
  if [[ "${html_anchor}" == "" ]]; then
    tac_site_link_name=$(echo "${s3_artifact}" | sed "s/ - iDX ${version_num}.*//" | sed "s/\([0-9_\-\.\-]\).*//g")
    #echo "tac_site_link_name=${tac_site_link_name}"
    html_anchor=$(echo "${html_releases}" | grep "${tac_site_link_name}")
    if [[ $(echo "${html_anchor}" | wc -l) == 2 ]]; then
      html_anchor="~/media/Files/TAC/Software Releases and Documentation/iDX/3/3/6/10/nmsclients15061021.zip"
    fi
  fi
  #echo "html_anchor=${html_anchor}"

  html_anchor=$(echo "${html_anchor}" | sed 's/ /%20/g')
  if ! [[ "${html_anchor}" =~ "http:" ]]; then
    html_anchor="${tac_domain}/${html_anchor}"
  fi

  echo -n "TAC..."
  curl -s -b $cookies_file -o "${tacdir}/${s3_artifact}" "${html_anchor}"
  if ! [[ $(file "${tacdir}/${s3_artifact}") =~ "Zip archive data" || \
    $(file "${tacdir}/${s3_artifact}") =~ "gzip compressed data" || \
    $(file "${tacdir}/${s3_artifact}") =~ "ISO 9660 CD-ROM" || \
    $(file "${tacdir}/${s3_artifact}") =~ "tar archive" ]]; then
    echo "Invalid File"
    echo "${release}/${s3_artifact}" >> ${errors_file}
    #rm -f "${tacdir}/${s3_artifact}"
    continue
  fi

  echo -n "S3..."
  aws s3 cp "s3://idirect-releases/${release}/${s3_artifact}" "${s3dir}/${s3_artifact}" ${profile} >/dev/null 2>&1
  file_type=$(file "${s3dir}/${s3_artifact}")
  if ! [[ $(file "${tacdir}/${s3_artifact}") =~ "Zip archive data" || \
    $(file "${tacdir}/${s3_artifact}") =~ "gzip compressed data" || \
    $(file "${tacdir}/${s3_artifact}") =~ "ISO 9660 CD-ROM" || \
    $(file "${tacdir}/${s3_artifact}") =~ "tar archive" ]]; then
    echo "Invalid File...Copying..."
    #echo "${release}/${s3_artifact}" >> ${errors_file}
    aws s3 cp "${tacdir}/${s3_artifact}" "s3://idirect-releases/${release}/${s3_artifact}" $profile >/dev/null 2>&1
    rm -f "${s3dir}/${s3_artifact}"

    aws s3 cp "s3://idirect-releases/${release}/${s3_artifact}" "${s3dir}/${s3_artifact}" ${profile} >/dev/null 2>&1
    file_type=$(file "${s3dir}/${s3_artifact}")
    if ! [[ $(file "${tacdir}/${s3_artifact}") =~ "Zip archive data" || \
      $(file "${tacdir}/${s3_artifact}") =~ "gzip compressed data" || \
      $(file "${tacdir}/${s3_artifact}") =~ "ISO 9660 CD-ROM" || \
      $(file "${tacdir}/${s3_artifact}") =~ "tar archive" ]]; then
      echo "Invalid File..."
      exit 0
    fi
  fi

  s3_md5sum=$(md5sum "${s3dir}/${s3_artifact}" | cut -d' ' -f1)
  tac_md5sum=$(md5sum "${tacdir}/${s3_artifact}" | cut -d' ' -f1)
  if [[ "${s3_md5sum}" != "${tac_md5sum}" ]]; then
    echo -n "NO MATCH...(${tac_md5sum} vs ${s3_md5sum}) Copying..."
    aws s3 cp "${tacdir}/${s3_artifact}" "s3://idirect-releases/${release}/${s3_artifact}" $profile > /dev/null 2>&1

    aws s3 cp "s3://idirect-releases/${release}/${s3_artifact}" "${s3dir}/${s3_artifact}" ${profile} >/dev/null 2>&1
    file_type=$(file "${s3dir}/${s3_artifact}")
    if ! [[ "${file_type}" =~ "Zip archive data" || "${file_type}" =~ "ISO 9660 CD-ROM" ]]; then
      echo "Invalid File..."
      exit 0
    fi
    echo "OK"
  else
    echo "OK"
  fi
  aws s3 cp "${tacdir}/${check_file}" "s3://idirect-releases/${release}/${check_file}" ${profile} >/dev/null 2>&1

  rm -f "${s3dir}/${s3_artifact}" "${tacdir}/${s3_artifact}"
  #read -p "Continue?> " answer </dev/stdin
  sleep 1
done
