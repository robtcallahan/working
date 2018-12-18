#!/bin/bash

site="http://tac.idirect.net/Home.aspx"
site="http://tac.idirect.net/sitecore/content/iDirectTac/Login/Home/Software-Releases/iDX/iDX-3/iDX-3_2_3/iDX-3_2_3-Software-and-Documentation-Downloads.aspx"

curl \
  --verbose \
  --cookie run/cookies.txt \
  --cookie-jar run/cookies.txt \
  "${site}"

#  --no-buffer \
#  --header "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36" \
# --insecure \
# --output run/curl.gz \
# --libcurl run/libcurl.txt \
# --location \
# --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
# --header "Accept-Encoding: gzip, deflate" \
# --header "Accept-Language: en-US,en;q=0.9,it;q=0.8,la;q=0.7" \
# --header "Connection: keep-alive" \
# --header "DNT: 1" \
# --header "Host: tac.idirect.net" \
# --header "Referer: http://tac.idirect.net/Home/Search-Page.aspx?SearchTerm=iDX+3.2.1+Restricted&CurrentPage=1" \
# --header "Upgrade-Insecure-Requests: 1" \
#  --header "Cache-Control: max-age=0" \
#  --include \
#  --dump-header run/header.txt \
#  --cookie-jar run/cookies.txt \
#  --trace-ascii run/trace.txt \
#  --header "Content-Length: 2278" \
