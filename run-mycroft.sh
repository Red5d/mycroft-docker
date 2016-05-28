#! /bin/bash

# Remove memory lock limit and increase available memory
#ulimit -r -l unlimited
ulimit -l unlimited
#mount -o remount,size=256M /dev/shm

# Start jackd server
jackd -d dummy &

# Start mycroft services
source ~mycroft/.virtualenvs/mycroft/bin/activate
PYTHONPATH=. python mycroft/messagebus/service/main.py &
sleep 2
PYTHONPATH=. python mycroft/skills/main.py &
sleep 5
ulimit -l unlimited
ulimit -a
PYTHONPATH=. python mycroft/client/speech/main.py

