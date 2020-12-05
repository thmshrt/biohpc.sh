# Biohpc #

# Biohpc.sh #

## TLDR ##

Skip the technical and dive right in with DivingIn.md

## Problem Context ##

**Biohpc and `docker` commands**

<span style="color:red;font-weight:bold">NOT UP TO DATE AS OF 20201202</span>

Biohpc has restricted / modified how we may interact with docker. 
The largest difference is the requirement that `docker` is now 
`docker1`. 

While from a dev ops point of view restricting user access is essential
to stability of the compute system, it greatly hinders the portability
of `.sh` scripts from your local machine to the biohpc cluster. 

For instance, if you had a simple script called `run-docker.sh` which
contained `docker run container -it mycontainer`, this script would
not work on biohpc.

This is where `sh-for-biohpc.sh` comes in. `sh-for-biohpc.sh` converts a
`.sh` script to a biohpc valid bash script. An examples call would be:

<span style="color:red;font-weight:bold">NEED TO UPDATE</span>

```sh
# semantics
# . sh-for-biohpc.sh <input file>
. sh-for-biohpc.sh config-local/instantiate.sh 
```

**Biohpc and `Dockerfile`s**

Biohpc has added a feature to the `docker1 build` process such that
dockerfiles built on biohpc will be named `biohpc_<username>/<docker tag>`.
As an example, my username is `thh4002`. If I were to create a docker
image with the command `docker1 build -t cowsay`, biohpc would create
a docker image with the name `biohpc_thh4002/cowsay`. 

This interferes with the `FROM <image>` line that begins EVERY 
dockerfile except in cases where `<image>` refers to an image 
located in dockerhub. To mitigate this issue `df-for-biohpc.sh`
will convert this line for you. An example call would be:

<span style="color:red;font-weight:bold">NEED TO UPDATE</span>

```sh
# syntax
# . df-for-biohpc.sh <input file> 
. df-for-biohpc.sh \
```

**Biohpc and `uid` and `gid`**

Biohpc restricts a container's ability to edit files. More specifically,
only those containers matching a biohpc user id and user group or
those container whose username and group is root can edit files on 
biohpc. (Root should never be the default user in a container. 
Additionally, some programs such as RStudio disallow logging in as
root).

A quick solution is to match your username in the container 
to that on biohpc by simply addind a new user as part of the 
build process with `uid` and `gid` that match yours. This solution, 
however, creates a portability problem. Other users cannot run
the container you've created as themselves. 

To fix this problem, there are couple of scripts. 
<span style="color:red;font-weight:bold">INCOMPLETE PARAGRAPH</span>

### Developing

<span style="color:red;font-weight:bold">OUTDATED SECTION</span>
Sometimes biohpc is down or you might want the comfort of 
developing on your local laptop. To facilitate this, there are two
separate, but equivalent configurations `config-biohpc` and 
`config-local`. `config-biohpc` is for developing on
biohpc. `config-local` if for developing on your local
machine. 

- `instantiate.sh` is a script for quickly creating a new container
`thh-rspatial` from the image `thh-rspatial`. You must edit or delete
the line containing `--volume` so either you remove the containers
access to the machine you are working on or you update the path to 
your case.

- `build-all.sh` is a script to build everything necessary to 
run `thh-rspatial`. This file does not need to be changed to run.

- `build-trunk.sh` is a script to build everything, but `thh-rspatial`.
This file does not need to be changed to run.

- `build-this.sh` is a script to build only `thh-rspatial`. 
This file does not need to be changed to run.

**REMEMBER**

Whenever moving scripts from your local machine to biohpc 
use `df-for-biohpc.sh` and `sh-for-biohpc.sh` to convert all of 
your new `.sh` scripts and all of your additional `Dockerfile`s
**AFTER** moving them to biohpc. This is  `sh-for-biohpc.sh`
and `df-for-biohpc.sh` need to know your username on biohpc
in order to update `.sh` scripts and `Dockerfile`s respectively.

**CAVEAT** 

THESE SCRIPTS ARE NOT EXHAUSTIVE AND ANY UPDATE MADE BY BIOHPC TO
`docker1` MAY CAUSE THESE SCRIPTS TO BECOME NONFUNCTIONAL.

## Other solutions ##

### Override `CMD` at run time ###

<span style="color:red;font-weight:bold">INCOMPLETE DESCRIPTION</span>
- requires
  - root access inside container

- example
```sh
docker run \
	--interactive \
	--tty \
	mycontainer \
	sudo su \
    && usermod \
	   --move-home --home /home/newbuntu \
	   --login newbuntu \
	   --shell /bin/bash \
	   ubuntu \
    && echo newbuntu:newbuntu | chpasswd \
    && echo "newbuntu ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && su newbuntu \
    && cd
```

### Use `--user` with `docker run` ###

<span style="color:red;font-weight:bold">INCOMPLETE DESCRIPTION</span>

- fails when
  - uid from outside container does not exist inside container

- requires
  - normal docker interface
  
- example
  ```sh
  docker run --interactive --tty --user newbuntu:1000 mycontainer 
  ```
