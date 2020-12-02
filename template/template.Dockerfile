
#BEGIN: ---------------- BUILD TIME ----------------

FROM <image>-<user>:latest

USER root

RUN usermod \
    --move-home --home /home/<user> ubuntu \
    --login <user> \
    --shell /bin/bash \
    --uid <uid> \
    # --groups <groups> \
    && echo <user>:<user> | chpasswd \
    && echo "<user> ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER <user>

#END:   ---------------- BUILD TIME ----------------

#BEGIN: ---------------- RUN TIME ----------------

CMD cd && /bin/bash

#END:   ---------------- RUN TIME ----------------

