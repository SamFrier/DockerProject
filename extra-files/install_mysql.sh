#!/bin/bash

# Root password is "root"
export DEBIAN_FRONTEND="noninteractive" 
#debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y mysql-server
