#!/bin/sh
# File to directly open ssh in vscode

ip=$(gcloud compute instances describe bishal-workspace-ubuntu --zone asia-south1-c --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

code  --folder-uri "vscode-remote://ssh-remote+bishal@${ip}/"
