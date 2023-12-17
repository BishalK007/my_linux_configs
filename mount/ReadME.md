# Step-by-step Guide

## Finding UUID of a Partition

1. Open a terminal window.

2. Type the following command and press Enter:
    ```bash
    sudo blkid
    ```
    This command will display the UUIDs for all partitions.

## Finding UIDs of Users

1. Open a terminal window.

2. Type the following command and press Enter:
    ```bash
    id $USER
    ```
    This command will display a list of all users along with their UIDs.
   
## edit mount.sh and add the mount.sh in a path /path_to_script & make it executable
     ```bash
    sudo chmod +x /path_to_script/mount.sh
    ```
## add script to crontab

1 . Open a terminal window.

2. Type the following command and press Enter:
    ```bash
    crontab -e
    ```
    This command will open crontab file.
   
3. Add the following line in crontab & save it:
    ```bash
    @reboot /path_to_script/mount.sh
    ```
    This command will frun the mount script on reboot.

Please note that you might need appropriate permissions to execute these commands. Always be careful when executing commands as a superuser.
