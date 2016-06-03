#!/bin/bash



projectdatafile="projects_data.csv"
userdatafile="users_data.csv"


#exporting users
usercounter=1
page=1

while [ "$page" -lt 3 ]    # this is loop1
do

apidata=$(curl -s "http://192.168.0.143/api/v3/users?page=$page&per_page=100&private_token=W8kdpTspXDjZ9vshe6Nu")
 
i=0
while [ "$i" -lt 99 ] 
do
	arr=`echo  "$apidata" | jq ".[$i]"`
	id=`echo  "$arr" | jq ".id"`
	name=`echo  "$arr" | jq ".name" | tr -d '"'`
	email=`echo  "$arr" | jq ".email" | tr -d '"'`

	if [ "$id" == "null" ] ; then 
		break
	fi

	echo "$id,$name,$email"
	echo "-------------------------"
	echo "$id,$name,$email" >> $userdatafile

	i=`expr $i + 1`
	usercounter=`expr $usercounter + 1`

done

	page=`expr $page + 1`
done


exit



#exporting projects and its data

projectcounter=1
page=1

while [ "$page" -lt 3 ]    # this is loop1
do

apidata=$(curl -s "http://192.168.0.143/api/v3/projects?page=$page&per_page=100&private_token=W8kdpTspXDjZ9vshe6Nu")
 
i=0
while [ "$i" -lt 99 ] 
do
	arr=`echo  "$apidata" | jq ".[$i]"`
	id=`echo  "$arr" | jq ".id"`
	name=`echo  "$arr" | jq ".name" | tr -d '"'`

	no=$projectcounter
	description=`echo  "$arr" | jq ".description"`
	http_url_to_repo=`echo  "$arr" | jq ".http_url_to_repo" | tr -d '"'`
	owner=`echo  "$arr" | jq ".owner.username" | tr -d '"'`
	created_at=`echo  "$arr" | jq ".created_at" | tr -d '"'`
	namespace=`echo  "$arr" | jq ".namespace.name" | tr -d '"'`

	if [ "$id" == "null" ] ; then 
		break
	fi

 
	echo "$no,$id,$name,$description,$http_url_to_repo,$owner,$created_at,$namespace" >> $projectdatafile
	echo "==========================================================="
	echo "$no,$id,$name,$http_url_to_repo,$owner,$namespace"
	echo "==========================================================="

	echo "Cloning $name..."

	# Clonning a mirror of repo 	
 	url_to_repo=`echo $http_url_to_repo | cut -c8-`
	git clone --mirror "http://saurabh:Constant@$url_to_repo" "/Users/saurabhsharma/Documents/gitbackup/$namespace/$name"


	i=`expr $i + 1`
	projectcounter=`expr $projectcounter + 1`

done

	page=`expr $page + 1`
done







