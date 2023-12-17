#!/bin/bash
echo <sudo-password> | sudo -S mount -t exfat UUID=<uuid> <mount-point> -o uid=<uid>,gid=<gid>

