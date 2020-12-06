## Diving Deeper ##

### Basic Worklow outside Biohpc ###

**create a directory**

```sh
mkdir myexample2
cd myexample2
```
	
**create `second.Dockerfile`**

```txt
FROM first:20.04
RUN touch $HOME/myfile
CMD cd && /bin/bash
```

**create `build-second.sh`**

```sh
sudo docker image build \
--tag second:latest \
--file second.Dockerfile \
`pwd`
```

**build image**

```sh
. build-second.sh
sudo docker image list
```

**create `instantiate-second.sh`**

```sh
sudo docker container run \
--interactive --tty \
--volume `pwd`:/home/ubuntu/currentdir \
second:latest
```

**instantiate**

```sh
. instantiate-second.sh
# you'll get a command prompt ubuntu@id
```

**edit file**

```sh
touch currentdir/myfile
```

### Basic Worklow on Biohpc ###

**create `second-for-me.Dockerfile`**

```txt
FROM first:20.04
RUN touch $HOME/myfile
ARG uid=6329
USER root
RUN usermod --uid $uid ubuntu
USER ubuntu
CMD cd && /bin/bash
```

**create `biohpc-build-second-for-me.sh`**

```sh
docker1 build \
-t second-for-me:latest \
--file second-for-me.Dockerfile \
--build-arg uid=$(id --user) \
`pwd`
```

**build image**

```sh
. biohpc-build-second-for-me.sh
# list images
docker1 images
```

**create `biohpc-instantiate-second-for-me.sh`**

```sh
docker1 container run \
--interactive --tty \
--volume `pwd`:/home/ubuntu/currentdir \
biohpc_$USER/second-for-me:latest
```

**instantiate**

```sh
. biohpc-instantiate-second-for-me.sh
# you'll get a command promt
```

**edit file**

```sh
touch currentdir/myfile
```

### Extended Workflow on Biohpc ###

#### Problems with "Extended Workflow outside Biohpc" ####

| Step                           | Succeeds | Reason                     |
|--------------------------------|----------|----------------------------|
| create a directory             | yes      |                            |
| create `second.Dockerfile`     | yes      |                            |
| create `build-second.sh`       | yes      |                            |
| build image                    | no       | first:latest doesn't exist |
| create `instantiate-second.sh` | yes      |                            |
| instantiate container          | no       | build image fails          |
| edit file                      | no       | build image fails          |

#### solving "build image" failure ####

