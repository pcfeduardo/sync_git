#!/bin/bash
# SyncGit - Git Pull Script
# Written by pcfeduardo
# pcfeduardo@vdzen.com

# To run script in background (if your webserver is nginx):
# nohup runuser -l nginx -c '/bin/bash /directory/sync_git.sh' &

# You can change this:
REPO_DIR=( \
			"/directory/of/your/project" \
)

startBanner(){
	echo -e "\n\e[33m============================================================\e[0m"
	echo -e "\e[33m(*) Starting $(date +"%d-%m-%Y %H:%M:%S")\e[0m"
	echo -e "\e[33m(*) Script written by pcfeduardo@vdzen.com \e[0m\n\n"
}

syncGit(){
	echo -e "\e[33m(*) Executing git clone on ${1}\e[0m"
	git --git-dir ${1}/.git --work-tree ${1} pull >> /dev/null
}

# Use only if you work in CakePHP Project
cakePhpClearCakeLockFiles(){
	echo -e "\e[33m(*) Removing ${1}/config/Migrations/schema-dump-default.lock\e[0m"
	rm -f ${1}/config/Migrations/schema-dump-default.lock
	echo -e "\e[33m(*) Removing ${1}/composer.lock\e[0m"
	rm -f ${1}/composer.lock
}

# Use only if you work in CakePHP Project
cakePhpMigrations(){
	echo -e "\e[33m(*) Changing permissions on ${1}/bin/cake\e[0m"
	chmod +x ${1}/bin/cake
	echo -e "\e[33m(*) Executing migrations on ${1}/bin/cake migrations migrate\e[0m"
	${1}/bin/cake migrations migrate >> /dev/null
}

# Use only if you work in CakePHP Project
cakePhpAclUpdate(){
	echo -e "\e[33m(*) Executing aco_update on ${1}/bin/cake acl_extras aco_update\e[0m"
	${1}/bin/cake acl_extras aco_update >> /dev/null
}


while [[ true ]]; do
	startBanner
    echo -e "\e[33m(*) Total of repositories: " ${#REPO_DIR[*]} " \e[0m \n"
    
    for ix in ${!REPO_DIR[*]}
    do
    	echo -e "\e[33m(*) Start ${REPO_DIR[$ix]}\e[0m"
    	
    	cakePhpClearCakeLockFiles "${REPO_DIR[$ix]}"
    	
    	syncGit "${REPO_DIR[$ix]}"
    	
    	cakePhpMigrations "${REPO_DIR[$ix]}"
    	
    	# cakePhpAclUpdate
    	
    	echo -e "\e[33m(*) End ${REPO_DIR[$ix]}\e[0m \n"
    done

	sleep 10
	
done
