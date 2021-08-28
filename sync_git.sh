#!/bin/bash
# SyncGit - Git Pull Script
# Written by pcfeduardo <pcfeduardo@gmail.com>

DIRNAME=`dirname ${BASH_SOURCE[0]}`
REPO_FILE="repo_file.txt"
FILENAME="${DIRNAME}/${REPO_FILE}"

startBanner(){
    echo -e "\n\e[33m============================================================\e[0m"
    echo -e "\e[33m(*) Starting $(date +"%d-%m-%Y %H:%M:%S")\e[0m"
    echo -e "\e[33m(*) Script written by pcfeduardo@gmail.com \e[0m\n\n"
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

startBanner

while read repo; do
    echo -e "\e[33m(*) Start ${repo}\e[0m"    
    cakePhpClearCakeLockFiles "${repo}"
    syncGit "${repo}"
    cakePhpMigrations "${repo}"
    # cakePhpAclUpdate
    echo -e "\e[33m(*) End ${repo}\e[0m \n"
done < "${FILENAME}"
