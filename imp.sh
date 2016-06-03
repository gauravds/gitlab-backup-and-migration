#!/bin/bash

projectdatafile="projects_data.csv"
userdatafile="users_data.csv"

#Importing project data 

while IFS=',' read -r id name username email
do
	echo "=================================================="
	
	apiresponse=$(curl -s POST -F name="$name" -F username="$username" -F email="$email" -F password=konstant http://192.168.0.31/api/v3/users?private_token=TQBGWxNyjx9wamk3iwdx)
	echo "Created - $name,$username,$email "
  	echo "=================================================="
  

done < "$userdatafile"

exit

#Importing project data 

while IFS=',' read -r namespace projectname description
do
	echo "=================================================="
	echo "$namespace $projectname $description"

	curl -X POST -v -F name=$projectname -F namespace_id=2 -F description=$description -F merge_requests_enabled=ture -F wiki_enabled=true -F snippets_enabled=true http://192.168.0.31/api/v3/projects?private_token=TQBGWxNyjx9wamk3iwdx

	cd /Users/saurabhsharma/Documents/gitbackup/Droid/$projectname

	git remote add gitlab31 http://root:konstant@192.168.0.31/$namespace/$projectname.git
	
	git push gitlab31 --mirror
  
  	echo "=================================================="
  
done < "$projectdatafile"