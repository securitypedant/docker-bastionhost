#!/bin/sh

# Start SSH
service ssh start

############
### User ###
############
useradd -ms /bin/bash $USER
usermod -aG sudo $USER
echo $USER:$USERPASS | chpasswd

/bin/bash