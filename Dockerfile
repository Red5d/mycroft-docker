FROM ubuntu

MAINTAINER red5d

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y git python python-dev python-virtualenv python-gobject-dev virtualenvwrapper \
libtool libffi-dev libssl-dev autoconf bison swig libglib2.0-dev s3cmd portaudio19-dev mpg123 jackd screen wget sudo
RUN dpkg-reconfigure -p high jackd

# Get latest version from mycroft-core github repo
RUN git clone https://github.com/MycroftAI/mycroft-core.git /mycroft-core

# Use modified version of install-pygtk.sh script because some of the curl downloads weren't working
COPY install-pygtk.sh /mycroft-core/install-pygtk.sh

# Add script to start mycroft services and .asoundrc file
COPY run-mycroft.sh /mycroft-core/run-mycroft.sh
COPY asoundrc /root/.asoundrc

WORKDIR /mycroft-core

# Create mycroft user to finish running setup from
RUN useradd -m mycroft && chown -R mycroft:mycroft /mycroft-core && usermod -a -G audio mycroft && echo "mycroft   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER mycroft

RUN ./dev_setup.sh

CMD sudo su -c ./run-mycroft.sh
