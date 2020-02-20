# docker-workspace
Dockerfile and related materials

This will build a docker image based on `fedora:latest` and with the right `docker run` options, allow you to have one or more local Windows directories mounted. In particular, ~/.ssh, and ~/.aws are of value. 

## Forthcoming Features and Fixes
- Terraform 11.11 & 12:latest
- Local executable or script to launch and manage container
- Customizable timezone (currently EST)


# Requirements
- Latest docker-ce for Windows
- A configured `.okta_aws_login_config` in the src folder

## Recommended
- awscli for Windows configured with at least a region and default output format.
- Powershell 6


# Build
- Clone this repository locally. 
- Ensure you have your own .okta_aws_login_config in the src directory.
- With the directory containing the Dockerfile as your current working directory, run the following command :

`docker build --build-arg username=userNAME -t imageNAME .` 

"*userNAME*" is the name you wish to give your local user.
"*imageNAME*" is the name you wish to give your image.


## Note on Build
If you run `docker images` and your image is not named correctly, you can fix this by running :
`docker tag HASH imageNAME:latest`

"*HASH*" is going to be the unique id for your image. 


# Run

To run and also mount your local Windows home directory for your container, be sure to first enable sharing from your Docker preferences for your C: drive.

Also note this will be running in daemon mode so you will not immediately drop into a shell, you'll need to attach first. See the section below on "Maintain" for more.

`docker run -it -d --name main --hostname docker -v ~/:/home/userNAME imageNAME`

`--name` & `--hostname` You can set this to whatever you like.

## Note on Run
Sharing your entire home directory has some security implications better understood in official documentation on sharing directories on Windows hosts with linux containers. Do so at your own risk.

You can make your blast radius smaller by using multiple `-v` volume mount flags in your run command to only share specific files or directories. 


# Maintain

Attach to your instance :
`docker attach HASH`

Start your container that has exited:
`docker start HASH`

Stop your container that is running once detached:
`docker stop HASH`

Exit your container while leaving it running:
`Ctrl+p+q`

## Notes on Maintain

Note that you can simply use the first letter (or first unique letter combination) of the hash of your image/container to reference it. 

ex:
```
>docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES                                   
ee00ab8bb916        privo               "/bin/bash"         6 days ago          Up 21 minutes                           main
```

```
>docker attach e
[user@docker docker-workspace]$
```

If you make changes to your container and want to save it as a new version of your image. You can run :
`docker commit containerID imageID:latest`