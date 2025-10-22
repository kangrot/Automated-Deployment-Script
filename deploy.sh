#!/bin/bash

set -euo pipefail

LOGFILE="deploy.log"

log() {
	export PS4='[\D{%F %T}] '
	
	exec > >(tee -a "$LOGFILE") 2>&1

	echo "$(date +'%Y-%m-%d %H:%M:%S')"

}

error_stop(){

	echo "ERROR: $1" | tee -a "$LOGFILE" >&2

 	exit "${2:-1}"
}

log

trap '" ERROR : Error on line $LINENO. Check $LOGFILE for details."; exit 1' ERR


echo "===Starting Deployment Script==="

echo "===Collecting Deployment Paramters==="


user_credentials(){

#GITHUB REPOSOSITORY

	read -p "Enter Git Repo URL : " GIT_URL

	while 
		[[ ! "$GIT_URL" =~ ^https://github\.com/.+\.git$ ]];
	
	do 
		echo "Invalid Github Repository URL"

		read -p "Re-enter Github Repository URl ; "GIT_URL

	done

#PERSONAL ACCESS TOKEN (PAT)

	read -p "Enter Personal Access Token (PAT) : " PAT

	while
		[[ -z "$PAT" ]];

	do
		echo "Something went wrong"

		read -p "Re-enter Personal Access Token: " PAT

	done

#BRANCH NAME

	read -p "Enter Branch Name ( Default is Main) : " BRANCH

	BRANCH=${BRANCH:-main}


#REMOTE SSH USERNAME

	read -p "Enter Remote SSH Username: " SSH_USERNAME
	
	while [[ -z "$SSH_USERNAME" ]];

	do
		echo "Something Went Wrong"

		read -p "Re-enter Remorte SSH Username:" SSH_USERNAME
	done

#REMOTE SERVER IP ADDRESS

	read -p "Enter Remote Server IP address: " SERVER_IP
	
	while [[ ! "$SERVER_IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; 

	do
    
		echo "Invalid IP address format."
    
		read -p "Re-enter Remote Server IP address: " SERVER_IP
	
	done

#SSH KEY PATH

	read -p "Enter SSH key path (e.g., ~/.ssh/id_rsa): " SSH_KEY

	SSH_KEY=$(eval echo "$SSH_KEY")

	while [[ ! -f "$SSH_KEY" ]]; 

	do
    
		echo "SSH key not found at $SSH_KEY."
    
		read -p "Re-enter SSH key path: " SSH_KEY

	done

#APPLICATION PORT

	read -p "Enter application port (container internal port): " APP_PORT

	while ! [[ "$APP_PORT" =~ ^[0-9]+$ ]] || (( APP_PORT < 1 || APP_PORT > 65535 )); 

	do
    
		echo "Invalid port number. Must be between 1–65535."
    
		read -p "Re-enter application port: " APP_PORT

	done
echo "Proceeding with deployment setup..."	
}

user_credentials
