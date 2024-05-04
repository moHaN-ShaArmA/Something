##!/bin/bash

function run-cmd ()
{
 echo ""
 echo ""
 echo "================================================================="
 echo " About to run : $1 "
 echo "-----------------------------------------------------------------"
 read -p "Proceed ? (Y/n)" choice
 if [ "$choice" = "n" ]
    then 
        echo "Bypassing...." 
    elif [ "$choice" = "N" ]
	then
       echo "Bypassing...." 
    else 
       echo "Running..."
	   $1
fi
}

####################################################

function sub-build-swapfile ()
{
 echo ""
 echo ""
 echo "================================================================="
 echo " About to build 2GB swapfile called /swapfile"
 echo "-----------------------------------------------------------------"
 read -p "Proceed ? (Y/n)" choice
 if [ "$choice" = "n" ]
    then 
        echo "Bypassing...." 
    elif [ "$choice" = "N" ]
	then
       echo "Bypassing...." 
    else 
    echo "Running..."
	if [ -f /swapfile ]; then
        echo "/swapfile already exists. Bypassing..."
    else 
        echo "/swapfile does not exist. Bulding /swapfile.."
        cd /
	    sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
	    sudo chmod 600 /swapfile
	    sudo mkswap /swapfile
	    sudo swapon /swapfile
	    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi
fi
}
####################################################

sub-enable-os-controlled-networking ()
{
 echo ""
 echo ""
 echo "================================================================="
 echo " Replace VPS Provider controlled networking with OS networking"
 echo "-----------------------------------------------------------------"
 read -p "Proceed ? (Y/n)" choice
 if [ "$choice" = "n" ]
    then 
        echo "Bypassing...." 
    elif [ "$choice" = "N" ]
	then
       echo "Bypassing...." 
    else 
    echo "Running..."
    sudo mmv '/etc/netplan/*.yaml' '/etc/netplan/#1.bak'  
	sudo wget https://cloudtechlinks.com/V47-cloudtech-dot-yaml  --output-document=/etc/netplan/v47-cloudtech-youtube-video.yaml
fi
}

####################################################

sub-install-nomachine ()
{
 echo ""
 echo ""
 echo "================================================================="
 echo " Install NoMachine v8.4.1 amd64  "
 echo "-----------------------------------------------------------------"
 read -p "Proceed ? (Y/n)" choice
 if [ "$choice" = "n" ]
    then 
        echo "Bypassing...." 
    elif [ "$choice" = "N" ]
	then
       echo "Bypassing...." 
    else 
       echo "Running..."
       sudo wget https://download.nomachine.com/download/8.4/Linux/nomachine_8.4.2_1_amd64.deb
       sudo apt install -f ./nomachine_8.4.2_1_amd64.deb
fi
}

####################################################

sub-install-and-configue-ufw ()
{
 echo ""
 echo ""
 echo "================================================================="
 echo " Install and Configure UFW - The Uncomplicated Firewall"
 echo "-----------------------------------------------------------------"
 read -p "Proceed ? (Y/n)" choice
 if [ "$choice" = "n" ]
    then 
        echo "Bypassing...." 
    elif [ "$choice" = "N" ]
	then
       echo "Bypassing...." 
    else 
       echo "Running..."
       sudo apt-get install ufw -y
       sudo ufw allow 22
       sudo ufw allow 4000
       sudo ufw enable
       sudo ufw status numbered
fi
}

####################################################

sub-configue-nomachine-user ()
{
 echo ""
 echo ""
 echo "================================================================="
 echo " Set up nomachine user & lock root user"
 echo "-----------------------------------------------------------------"
 read -p "Proceed ? (Y/n)" choice
 if [ "$choice" = "n" ]
    then 
        echo "Bypassing...." 
    elif [ "$choice" = "N" ]
	then
       echo "Bypassing...." 
    else 
    echo "Running..."
    sudo adduser nomachine
         #(example password : paste  se7ye8pc5hs0  )
    sudo usermod -aG sudo,adm,lp,sys,lpadmin nomachine
    sudo passwd --delete --lock rootuser
fi
}

####################################################

#----------------------#
# MAIN ROUTINE FOLLOWS #
# ---------------------#
run-cmd "sudo apt-get update" 
run-cmd "sudo apt-get upgrade -y" 
run-cmd "sudo apt-get install ubuntu-desktop -y"
run-cmd "sudo apt-get install stacer -y"
run-cmd "sudo apt-get install mmv -y"

run-cmd "sudo apt-get install firefox -y"
run-cmd "sudo apt-get install qdirstat -y"

sub-build-swapfile

sub-enable-os-controlled-networking 

sub-install-nomachine

sub-install-and-configue-ufw

sub-configue-nomachine-user

run-cmd "sudo reboot"
             
# ========= SCRIPT END ============
