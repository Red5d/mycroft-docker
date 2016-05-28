# Mycroft Docker
Dockerizing [Mycroft AI](https://github.com/MycroftAI/mycroft-core).

Currently works (tested on Antergos ArchLinux), but seems to stop listening after a while sometimes. Could be interference from the 
host audio system. I welcome any insight/suggestions for this.

It's based on the latest ubuntu image right now since the mycroft-core instructions were written for Ubuntu, so the image size is a 
little over 2GB. I'm going to work on switching it to an alpine base to reduce the size though.


# Usage
Build the docker image:

    docker build -t mycroft .

Then run it with docker-compose:

    docker-compose up -d

...or the command in the top of the docker-compose.yml file.

