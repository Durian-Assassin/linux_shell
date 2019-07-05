#!/bin/bash

function checkIpInWhiteList(){
    #Cat ips in the white ip list
    white_ip=`cat ./mail_white_list.conf`
    contain=0
    
    #printf "$1\n"

    for read_line in $white_ip
    do
        if [ $1 = $read_line ]	
        then
	    contain=1
	    break
        fi
    done
    return $contain
}

function netstatCheck(){
    now_connection=`netstat -tan | sed -e '1,2d' | awk  '{print $5}' | grep -E "192.168" | awk -F '[:]' '{print($1)}' | uniq`

    for ip_connection in $now_connection
    do
	checkIpInWhiteList $ip_connection
	contain_flag=$?
	if [[ $contain_flag == 1 ]]
	then
	    printf ""$ip_connection" -----白名单\n"
	    continue
	else
	    printf ""$ip_connection" -----未知IP\n"
        fi
    done
}

function check(){
    while :
    do
        printf "=======start=======\n"
        printf "`date +%Y-%m-%d,%H:%m:%s`\n"
        netstatCheck
        printf "\n"
        sleep 10
    done
}

check | tee -a check.log
