#/bin/bash

#save the sha256 of directory
find /root/wordpress/wordpress/ -depth -type f -name "*.php" | xargs sha256sum  > ./wordpress.sha256
ls /root/wordpress/wordpress | xargs -n1 | sort > ./wordpressDirectory.log
file_list=`cat ./wordpressDirectory.log`

#check the sha256 file to monitor the modifying or adding in the directory
function checkSha256(){

    while true
    do
	ls /root/wordpress/wordpress | xargs -n1 > ./wordpressDirectory_new.log
	
	file_list_new=`cat ./wordpressDirectory_new.log`

	printf "========start to check sha256 of files=========\n"
	printf "`date +%Y-%m-%d,%H:%m:%s`\n"
	
	for read_line_new in $file_list_new
	do 
	    flag=0
	    for read_line in $file_list
	    do
		if [ $read_line_new = $read_line ]
		then
		    flag=1
		fi
	    done
	    if [ $flag == 0 ]
	    then
	        echo "-----------------$read_line_new is new created by hacker!"
	    fi
	done	

	sha256sum -c ./wordpress.sha256 | grep -E 'FAILED$' | awk '{print($1)}' | sed -e 's/://g' | xargs -I {} printf {}'------has been modified!\n' > ./checkOut.log
	count=`cat ./checkOut.log | wc -l`

	if [[ $count == 0 ]]
	then
	    printf "All files are OK!\n"
	else
	    cat ./checkOut.log	   
	fi
	
	sleep 10
    done

}

checkSha256
