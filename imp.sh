#!/bin/bash

projectdatafile="projects_data.csv"
userdatafile="users_data.csv"
namespace_Droid_id=2
namespace_iOS_id=3
namespace_mobile_php_id=223
namespace_PL_DD_id=222
namespace_PL_Yogi_id=224
namespace_Admin=1

#Importing project data 

while IFS=',' read -r id name username email
do
	echo "=================================================="
	
	apiresponse=$(curl -s POST -F name="$name" -F username="$username" -F email="$email" -F password=konstant http://192.168.0.31/api/v3/users?private_token=TQBGWxNyjx9wamk3iwdx)
	echo "Created - $name,$username,$email "
 	echo "=================================================="
  

done < "$userdatafile"



#Importing project data 
#1,110,ButlerIGA,"Butler IGA droid app",http://192.168.0.143:8080/droid/butleriga.git,saurabh,2013-11-26T12:20:36Z,Droid

while IFS=',' read -r sno id projectname projectdesc projectgiturl projectowner projectcreatedat projectnamespace
do

	echo "$projectnamespace | $projectowner | $projectname"
	echo "=================================================="

	#setting a default default namespace id 
	namespace_id="$namespace_Admin"

 	if [ "$projectnamespace" == "iOS" ] ; then 
		 namespace_id="$namespace_iOS_id"
	fi
 	if [ "$projectnamespace" == "Droid" ] ; then 
		 namespace_id="$namespace_Droid_id"
	fi
 	if [ "$projectnamespace" == "PL-DD" ] ; then 
		 namespace_id="$namespace_PL_DD_id"
	fi
 	if [ "$projectnamespace" == "mobile-php" ] ; then 
		 namespace_id="$namespace_mobile_php_id"
	fi
 	if [ "$projectnamespace" == "PL-Yogi" ] ; then 
		 namespace_id="$namespace_PL_Yogi_id"
	fi

 
	apiresponse=$(curl -s POST -F name="$projectname" -F namespace_id="$namespace_id" -F description="$projectdesc" -F merge_requests_enabled=ture -F wiki_enabled=true -F snippets_enabled=true http://192.168.0.31/api/v3/projects?private_token=TQBGWxNyjx9wamk3iwdx)

	cd /Users/saurabhsharma/Documents/gitbackup/"$projectnamespace"/"$projectname"

	projectnamesmall=`echo "$projectname" | tr '[:upper:]' '[:lower:]'`

	git remote add gitlab31 http://root:konstant@192.168.0.31/"$projectnamespace"/$projectnamesmall.git
	
	git push gitlab31 --mirror
  
  	echo "=================================================="
 
  
done < "$projectdatafile"

