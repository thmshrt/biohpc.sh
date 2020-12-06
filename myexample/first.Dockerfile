FROM ubuntu:20.04
RUN useradd ubuntu
USER ubuntu
CMD cd && /bin/bash
