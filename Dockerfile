#BEGIN ---------------- BUILD TIME

FROM ubuntu:20.04

#BEGIN   -------- CUSTOMIZE USER

# this would already have been done
# ubuntu may be replace with whatever
# user name the previous container uses
RUN `# create user` \
    && useradd \
	   --create-home \
	   --shell /bin/bash \
	   ubuntu

# everything below goes at the END
# of the dockerfile
USER root

RUN `# install parallel to help` \
    && apt update \
    && apt install --assume-yes \
	   parallel \
    && `# clean up` \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# set defaults
# docker does not accept `expr` or $(expr) 
# therefore we must use  "$()" to wrap expressions
ARG uid="$(id --user ubuntu)"
ARG gid="$(id --group ubuntu)"
ARG gids="$(id --groups ubuntu | sed 's/ /,/g')"
ARG group_names="$(id --groups --name ubuntu | sed 's/ /,/g')"

# create groups and modify user
RUN `# create groups` \
    && uid=$(eval echo $uid) \
    && gid=$(eval echo $gid) \
    && gids=$(eval echo $gids) \
    && group_names=$(eval echo $group_names) \
    && echo uid: $uid \
    && echo gid: $gid \
    && echo gids: $gids \
    && echo group_names: $group_names \
    && parallel --delimiter , \
		groupadd --force --gid {1} {2} \
		::: $gids \
		:::+ $group_names \
    && `# modify user` \
    && echo usermod --uid $uid ubuntu --gid $gid --groups $gids ubuntu  \
    && usermod --uid $uid --gid $gid --groups $gids ubuntu

USER ubuntu

#END   -------- CUSTOMIZE USER

#END   ---------------- BUILD TIME

#BEGIN ---------------- RUN TIME

ENTRYPOINT cd && /bin/bash

#END   ---------------- RUN TIME
