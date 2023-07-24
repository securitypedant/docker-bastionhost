# Ubuntu bastion host in Docker
Simple server I use for a docker enviornment where I want to test the environment from the docker container perspective.

## Building the container

docker build -t bastionserver -f Dockerfile .

docker buildx build --platform linux/amd64,linux/arm64 --build-arg USER=simon --build-arg USERPASS=123qweQWE --push -t simonsecuritypedant/bastionhost:1.0 -t simonsecuritypedant/bastionhost:latest -f Dockerfile .

## Note to connect to the host with a Cloudflare tunnel and render ssh in browser, follow these instructions.
https://developers.cloudflare.com/cloudflare-one/identity/users/short-lived-certificates/#7-connect-as-a-user