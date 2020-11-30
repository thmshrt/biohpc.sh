

## Problem ##

- different users have different `uid` on different systems
- if `uid` inside and outside the container differ, container cannot write

### Use template files ###

- fails when
  - user cannot create a new image
  - user does not want to create a new image

- requires
  - multiple files
  
- process
  - create additional image on top of current
  - update primary user inside container to have same `uid`, `gid`

## Other solutions ##

### Override `CMD` at run time ###

- requires
  - root access inside container
  
```sh
# oneline cmd
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

- fails when
  - uid from outside container does not exist inside container

- requires
  - normal docker interface
  
- process
  - use `--user uid:gid` in `docker run`
