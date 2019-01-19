#!/bin/bash

#aws s3 ls s3://idirect-releases --profile idirect-enterprise | sed -e 's/^\s\+//' | sed -e 's/\/$//'

profile="--profile idirect-enterprise"
s3bucket="idirect-enterprise-prod-releases-origin"
#domain="https://d8lkzio2al7h7.cloudfront.net"
domain="https://d1uhtjulqigxza.cloudfront.net"

aws s3 ls s3://$s3bucket --recursive $profile | awk '{$1="";$2="";$3=""; print $0}' | sed -e 's/^\s\+//' | while read -r file
do
  if [[ $file =~ /$ ]];
  then
    continue
  else
    display_name=""
    if [[ "${file}" =~ Hub\ Packages ]]; then
      display_name="Hub Packages - Evolution Hub line card package"
    elif [[ "${file}" =~ Remote\ Packages ]]; then
      display_name="Remote Packages - Evolution remote package"
    elif [[ "${file}" =~ IDS- ]]; then
      display_name="NMS and PP ISO - NMS and Protocol Processor server image"
    elif [[ "${file}" =~ nms_clients ]]; then
      display_name="NMS Clients - iBuilder, iMonitor, and iSite clients"
    elif [[ "${file}" =~ udpblast ]]; then
      display_name="UDPBlast - optional software tool for generating UDP traffic"
    elif [[ "${file}" =~ checkcksh ]]; then
      display_name="check_ck - required script to identify any custom keys on remotes and line cards"

    elif [[ "${file}" =~ iDirect_IGW_S2- ]]; then
      display_name="FX2_PP_S2 ISO - PP image for FX2 server in a DVB-S2 network"

    elif [[ "${file}" =~ iDirect_IGW_EVO_S2X- ]]; then
      display_name="iGW_EVO_S2X.ISO - iGateWay server image in a DVB-S2x network"
    elif [[ "${file}" =~ iDirect_IGW_EVO_S2X_upgrade ]]; then
      display_name="iGW_EVO_S2X_upgrade.tar - iGateway upgrade software in a DVB-S2x network"

    elif [[ "${file}" =~ iDirect_IGW_EVO_S2- ]]; then
      display_name="iGW_EVO_S2.ISO - iGateWay server image in a DVB-S2 network"
    elif [[ "${file}" =~ iDirect_IGW_EVO_S2_upgrade ]]; then
      display_name="iGW_EVO_S2_upgrade.tar - iGateway upgrade software in a DVB-S2 network"

    elif [[ "${file}" =~ iDirect_PP_EVO_S2X- ]]; then
      display_name="R630_PP_EVO_S2X - PP image for R630 server in a DVB-S2 network"
    elif [[ "${file}" =~ iDirect_PP_EVO_S2X_upgrade ]]; then
      display_name="R630_PP_EVO_S2X_upgrade - PP software upgrade for R630 server in a DVB-S2 network"

    elif [[ "${file}" =~ iDirect_IGW- ]]; then
      display_name="iGW ISO - iGateWay server image"
    elif [[ "${file}" =~ iDirect_IGW_upgrade ]]; then
      display_name="iGW.tar - iGateWay Upgrade software"

    elif [[ "${file}" =~ iQUpdateUtility ]]; then
      display_name="iQ Update Utility - iQ Desktop Upgrade Utility"

    elif [[ "${file}" =~ ec-controller-.*\.ovf ]]; then
      display_name="ECC Package OVF"
    elif [[ "${file}" =~ ec-controller-.*\.mf ]]; then
      display_name="ECC Package MF"
    elif [[ "${file}" =~ ec-controller-.*\.vmdk ]]; then
      display_name="ECC Package VMDK"

    elif [[ "${file}" =~ meshecc|mesh-ecc ]]; then
      display_name="Mesh ECC Package"
    elif [[ "${file}" =~ meshsbc|mesh-sbc ]]; then
      display_name="Mesh Receiver Packages"

    elif [[ "${file}" =~ Mesh\ ECC\ Package ]]; then
      display_name="Mesh ECC Package"
    elif [[ "${file}" =~ Mesh\ Receiver\ Packages ]]; then
      display_name="Mesh Receiver Packages"

    elif [[ "${file}" =~ iDX-3_2-PreUpgrade-Script ]]; then
      display_name="iDX Release 3.2 Pre-Upgrade Script - This script is required for network upgrades from pre-iDX 3.2 releases"

    elif [[ "${file}" =~ ipan-lte-date-cg-production ]]; then
      display_name="CG ISO"
    elif [[ "${file}" =~ ipan-lte-date-omc-production ]]; then
      display_name="OMC ISO"
    elif [[ "${file}" =~ OMC\ Package ]]; then
      display_name="OMC Package"
    elif [[ "${file}" =~ LG\ Package ]]; then
      display_name="LG Package"
    elif [[ "${file}" =~ CG\ Package ]]; then
      display_name="CG Package"
    elif [[ "${file}" =~ cdm ]]; then
      display_name="CDM - CG Package"
    elif [[ "${file}" =~ neMgmt ]]; then
      display_name="neMgmt - CG Package"

    else
      display_name=""
    fi

    echo '"'${display_name}'"',${file},${domain}/$(echo ${file} | sed -e 's/ /%20/g')
  fi
  #echo $file,http://d8lkzio2al7h7.cloudfront.net/$file
  #aws s3 cp "s3://$s3bucket/$file" "$file" $profile
done
