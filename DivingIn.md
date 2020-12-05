## Diving In ##

### Basic Workflow outside Biohpc ###

**create a directory**
	```sh
	mkdir myexample
	cd myexample
	```
	
**create `first.Dockerfile`**
	```txt
	FROM ubuntu:20.04
	RUN useradd ubuntu
	USER ubuntu
	CMD cd && /bin/bash
	```

**create `build-first.sh`**
	```sh
	sudo docker image build \
	--tag first:latest \
	--file first.Dockerfile \
	`pwd`
	```

**build image**
	```sh
	. build-first.sh
	sudo docker image list
	```
	
**create `instantiate-first.sh`**
	```sh
	sudo docker container run \
	--interactive --tty \
	--volume `pwd`:/home/ubuntu/currentdir \
	first:latest
	```

**instantiate**
	```sh
	. instantiate-first.sh
	# you'll get a command prompt ubuntu@id
	```

**edit file**
	```sh
	touch currentdir/myfile
	```

### Basic Workflow on Biohpc ###

#### Problems with "Basic Workflow outside Biohpc" ####

| Step                    | Succeeds | Reason             |
|-------------------------|----------|--------------------|
| create a directory      | yes      |                    |
| create `Dockerfile`     | yes      |                    |
| create `build.sh`       | yes      |                    |
| build image             | no       | no sudo privileges |
| create `instantiate.sh` | yes      |                    |
| instantiate container   | no       | build image fails  |
| edit file               | no       | build image fails  |

#### solving "build image" failure ####

**create `biohpc-build-first.sh`**
	- use `docker1 build` instead of `sudo docker image build`
	- use `-t` instead of `--tag`
	- understand that image will be name `biohpc_<user>/tag`
	- understand `docker1` requires file to begin `/workdir/$USER/...`
	```sh
	docker1 build \
	-t first:latest \
	--file first.Dockerfile \
	cd /workdir/$USER/myexample/
	```

**build image**
	```sh
	. biohpc-build-first.sh
	# sudo docker image list
	docker1 images
	```

**instantiate**
	```sh
	. instantiate-first.sh
	# you'll get a command prompt ubuntu@id
	```

**edit file**
	```sh
	touch currentdir/myfile
	```

#### Problems with Updated Workflow ####

| Step                    | Succeeds | Reason                     |
|-------------------------|----------|----------------------------|
| create a directory      | yes      |                            |
| create `Dockerfile`     | yes      |                            |
| create `build.sh`       | yes      |                            |
| build image             | yes      |                            |
| create `instantiate.sh` | yes      |                            |
| instantiate container   | no       | no sudo priveleges         |
| edit file               | no       | instatiate container fails |

#### solving "instantiate container" failure ####

**create `instantiate-first.sh`**
	- use `docker1` instead of `sudo docker`
	- understand that image will be name `biohpc_$USER/tag`
	```sh
	docker1 container run \
	--interactive --tty \
	--volume `pwd`:/home/ubuntu/currentdir \
	biohpc_$USER/first:latest
	```
	
**instantiate**
	```sh
	. instantiate-first.sh
	# you'll get a command prompt ubuntu@id
	```

**edit file**
	```sh
	touch currentdir/myfile
	```
	
#### Problems with UpUpdated Workflow ####

| Step                    | Succeeds | Reason               |
|-------------------------|----------|----------------------|
| create a directory      | yes      |                      |
| create `Dockerfile`     | yes      |                      |
| create `build.sh`       | yes      |                      |
| build image             | yes      |                      |
| create `instantiate.sh` | yes      |                      |
| instantiate container   | yes      |                      |
| edit file               | no       | incorrect priveleges |


#### solving "edit file" failure ####

**create `first_for_me.Dockerfile`**
	- use results of `id --user` instead of 6329
	```sh
	FROM ubuntu:20.04
	RUN useradd ubuntu 
	RUN usermod --uid 6329
	USER ubuntu
	CMD cd && /bin/bash
	```

**create `biohpc-build-first-for-me.sh`**
	```sh
	docker1 build \
	-t first-for-me:latest \
	--file first-for-me.Dockerfile \
	cd /workdir/$USER/myexample/
	```

**build image**
	```sh
	. biohpc-build-first-for-me.sh
	# sudo docker image list
	docker1 images
	```

**create `instantiate-first-for-me.sh`**
	```sh
	docker1 container run \
	--interactive --tty \
	--volume `pwd`:/home/ubuntu/currentdir \
	biohpc_$USER/first-for-me:latest
	```
	
**instantiate**
	```sh
	. instantiate-first-for-me.sh
	# you'll get a command prompt ubuntu@id
	```
**edit file**
	```sh
	touch currentdir/myfile
	```

**edit file**
	```sh
	touch currentdir/myfile
	```

#### All Stages of UpUpUpdated Workflow ####

| Step                    | Succeeds | Reason |
|-------------------------|----------|--------|
| create a directory      | yes      |        |
| create `Dockerfile`     | yes      |        |
| create `build.sh`       | yes      |        |
| build image             | yes      |        |
| create `instantiate.sh` | yes      |        |
| instantiate container   | yes      |        |
| edit file               | yes      |        |
