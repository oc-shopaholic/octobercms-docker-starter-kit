# Prepare local environment

Install **docker, ansible, make**.
For Ubuntu: ```sudo bash bash/install-ubuntu.sh```.
For Linux Mint: ```sudo bash bash/install-mint.sh```.

You need **reboot** system, after running the bash script.

# Project initialisation

* You need change *.yml file with global vars in folder **ansible/vars/global**
* You need change *.yml file with local vars in folder **ansible/vars/local**
* You need 
* Run ```make init-local-env```