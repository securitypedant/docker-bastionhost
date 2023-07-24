################################
### We use a java base image ###
################################
FROM ubuntu:22.04

#########################################
### Maintained by Simon Thorpe        ###
### Contact: simon@securitypedant.com ###
#########################################
LABEL maintainer="Simon Thorpe <simon@securitypedant.com>"

##########################
### Environment & ARGS ###
##########################
ENV PERSIST_DATA_PATH=/data/

###########################
###   Add basic tools   ###
###########################
RUN apt-get update && apt-get upgrade -y
RUN apt-get install iputils-ping traceroute dnsutils net-tools iproute2 -y
RUN apt-get install nano ne -y
RUN apt-get install bash sudo curl -y

###########################
###    Setup network    ###
###########################
RUN apt-get install openssh-server -y
RUN apt-get clean

#######################################
###  Directory and data structure   ###
#######################################
RUN mkdir ${PERSIST_DATA_PATH}

# Need to setup Cloudflare short lived certs. I think if we do this, we don't need to set password on the user.
# https://developers.cloudflare.com/cloudflare-one/identity/users/short-lived-certificates/
# Copy cert file into machine
COPY ./cloudflare-ca.pub /etc/ssh/cloudflare-ca.pub
# Edit ssh config to use cert
RUN sed -i -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i -e '/PubkeyAuthentication yes/a TrustedUserCAKeys /etc/ssh/cloudflare-ca.pub' /etc/ssh/sshd_config

###############
### Volumes ###
###############
VOLUME "${PERSIST_DATA_PATH}"

###############################
### Expose SSH ports  ###
###############################
EXPOSE 22

################### 
### Healthcheck ###
###################
# FIXME: This should monitor the SSH server and fail if SSH doesn't work
#HEALTHCHECK --interval=10s --timeout=5s --start-period=120s \
#    CMD mcstatus localhost:$( cat $PROPERTIES_LOCATION | grep "server-port" | cut -d'=' -f2 ) ping


######################################
### Entrypoint is the start script ###
######################################
# Copy the script to the container
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Run Command
# CMD [ "" ]
