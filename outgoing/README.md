# Hart_MALDI

## Getting Started

### On Your Local Machine

```sh
git clone https://gitlab.com/krumsieklab/hart_maldi.git
cd hart_maldi/

# modify hart_maldi/config/config-local/instantiate.sh 
# so that the line starting with --volume matches the path
# to the correct directory on your local machine
. config/config-biohpc/instantiate.sh
```

### On Biohpc

**on your local machine**

```sh
# TODO
# create ssh tunnel to biohpc
```

**on biohpc**

```sh
git clone https://gitlab.com/krumsieklab/hart_maldi.git
cd hart_maldi/

# modify hart_maldi/config/config-biohpc/instantiate.sh 
# so that the line starting with --volume matches the path
# to the correct directory on your local machine
. config/config-biohpc/instantiate.sh
```

## Documentation

A gitbook is soon to be available in `hart_maldi/examples/showcase`.

## Docker

### Directory Structure
```
config/
	config-biohpc/
		build-all.sh
		build-this.sh
		build-trunk.sh
		dockerfiles/
			docker-trunk.txt
			thh-conda.Dockerfile
			thh-editors.Dockerfile
			thh-r.Dockerfile
			thh-rspatial.Dockerfile
			thh-tidyr.Dockerfile			
		instantiate.sh
	config-local/
		build-all.sh
		build-this.sh
		build-trunk.sh
		dockerfiles/
			docker-trunk.txt
			thh-conda.Dockerfile
			thh-editors.Dockerfile
			thh-r.Dockerfile
			thh-rspatial.Dockerfile
			thh-tidyr.Dockerfile			
		instantiate.sh
	df-for-biohpc.sh
	sh-for-biohpc.sh
```

### What is all this?

**Biohpc and `docker` commands**

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

```sh
# semantics
# . sh-for-biohpc.sh <input file> <output file>
. sh-for-biohpc.sh config-local/instantiate.sh config-biohpc/instantiate.sh
```

**Biohpc and `Dockerfile`s**

Biohpc has added a feature to the `docker1 build` process such that
dockerfiles built on biohpc will be named `biohpc_<username>/<docker tag>`.
As an example, my username is `thh4002`. If I were to create a docker
image with the command `docker1 build -t cowsay`, biohpc would create
a docker image with the name `biohpc_thh4002/cowsay`. 

This interferes with the `FROM <image>` line that begins EVERY 
dockerfile. To mitigate this issue `df-for-biohpc.sh` will convert
this line for you. An example call would be:

```sh
# syntax
# . df-for-biohpc.sh <input file> <output file>
. df-for-biohpc.sh \
  config-local/dockerfiles/thh-editors.Dockefile \
  config-biohpc/dockerfiles/thh-editors.Dockefile
```

**Biohpc and permissions**

Biohpc restricts a container's ability to edit files. More specifically,
only those containers matching a biohpc user name and user group or
those container whose username and group is root can edit files on 
biohpc. (Root should never be the default user in a container. 
Additionally, some programs such as RStudio disallow logging in as
root).

A quick solution is to match your username in the container 
to that on biohpc, however the problem is not so simple, your
username as well as your `uid` and `gid` must match on biohpc and
 inside a container.

Hence to fix this problem, you will need to find out your `uid`
and `gid`. User the `id` command:

```sh
id
```

Then modify the appropriate section in `config-biohpc/thh-editors.Dockerfile`
and `config-local/thh-editors.Dockerfile` to create a new user with
your `uid` and `gid`. Additionally you'll need to replace my username
 `thh4002` with your username in the rest of the files.

I'm working on automating this with a bash script, so hang tight!

### Developing

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