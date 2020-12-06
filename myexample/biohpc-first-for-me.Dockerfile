FROM ubuntu:20.04
RUN useradd ubuntu 
ARG uid=6329
RUN usermod --uid $uid ubuntu
USER ubuntu
CMD cd && /bin/bash
