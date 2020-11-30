
#BEGIN: ---------------- BUILD TIME ----------------

FROM editors:latest

USER root

RUN usermod \
    --move-home --home /home/newbuntu \
    --login newbuntu \
    --shell /bin/bash \
    --uid 1001 \
    # --groups <groups> \
    ubuntu \
    && echo newbuntu:newbuntu | chpasswd \
    && echo "newbuntu ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER newbuntu

#END:   ---------------- BUILD TIME ----------------

#BEGIN: ---------------- RUN TIME ----------------

CMD cd && /bin/bash

#END:   ---------------- RUN TIME ----------------

