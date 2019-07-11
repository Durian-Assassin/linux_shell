#!/bin/bash

# difine the function to kill process
function killProcess(){

    read -p "Please enter the name of process:" processName
    # printf $processName"\n"
    
    if [[ $processName = "" ]]
    then 
        printf "Please enter the name of process!\n"
        return
    else
        pid=$(ps -ef | grep -E $processName | grep -v "grep" | awk '{print $2}')
        pidArray=$(ps -ef | grep -E $processName | grep -v "grep" | awk '{print $0}')
        pidCount=$(ps -ef | grep -E $processName | grep -v "grep" | awk '{print $2}' | wc -l)
       # printf "Process pid is: "$pid"\n"
    fi
    
    
    if [[ -z $pid ]]
    then
        printf "Not found the process!\n" 
        return
    else
	if [[ ${pidCount} == 1 ]]
	then
	    printf "$pidArray\n"
	    read -p "Please confirm the pid(y/n):" res
	    if [ $res = "y" ]
	    then
                kill -9  $pid
	        exit $?
	    else
		return
	    fi
	else
	    printf "Find these process:\n"
	    printf "${pidArray[@]}\n"
	    read -p "Please enter the pid:" pid
	    kill -9 $pid 
	    exit $?
	fi

    fi
}

while true
do 
    killProcess
done
