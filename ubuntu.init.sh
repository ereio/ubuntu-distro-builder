#!/bin/bash
echo 'Defaults:ereio timestamp_timeout=120' | sudo EDITOR='tee -a' visudo
nohup ./ubuntu.main.sh & disown
echo $! > pid.txt
tail -f ./nohup.out
