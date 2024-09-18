FROM alpine:latest
LABEL maintainer="Norbert Skurnóg <norbert.skurnog@gmail.com>"

RUN echo '#!/bin/bash\n/usr/bin/vncserver :99 &\n/opt/noVNC/utils/novnc_proxy --vnc 127.0.0.1:5999\n' > /entry.sh \
    && apk add bash sudo git xfce4 python3 tigervnc xfce4-terminal firefox \
    && adduser -h /home/alpine -s /bin/bash -S -D alpine \
    && echo -e "alpine\nalpine" | passwd alpine \
    && echo 'alpine ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && git clone https://github.com/novnc/noVNC /opt/noVNC \
    && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

USER alpine
WORKDIR /home/alpine

RUN mkdir -p /home/alpine/.vnc \
    && echo -e "#!/bin/bash\nstartxfce4 &" > /home/alpine/.vnc/xstartup \
    && echo -e "alpine\nalpine\nn\n" | vncpasswd

COPY entry.sh /entry.sh
CMD ["/bin/bash", "/entry.sh"]
