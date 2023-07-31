#_____________ Variables _______________
gitPromptPath='/usr/share/git-core/contrib/completion/'

#______________My Commands _______________
source $gitPromptPath/git-prompt.sh
export PS1='\[\033[38;5;226m\] >-<\n\[\033[38;5;46m\] \u\[\033[38;5;241m\]@\[\033[38;5;39m\]\h \[\033[38;5;45m\]\w \[\033[38;5;46m\]$(__git_ps1 " (%s)")\n\[\033[38;5;226m\] >-< \n\[\033[38;5;39m\] •‿• \[\033[0m\] '
#_____________My Aliases____________________

function runFlutterOnWeb() {
    if [[ "$(nmcli -t -f DEVICE,STATE dev)" == *"eno1:connected"* ]]; then
        # Alias for Ethernet connection
        echo "!!__Running Flutter on Ethernet connection__!!"
        flutter run -d web-server --web-hostname 192.168.29.10
        # Add your command or alias for Ethernet here    
    elif [[ "$(nmcli -t -f DEVICE,STATE dev)" == *"wlo1:connected"* ]]; then
        # Alias for Wi-Fi connection
        echo "!!__Running Flutter on WIFI connection__!!"
        flutter run -d web-server --web-hostname 192.168.29.20
        # Add your command or alias for Wi-Fi here
    else
        echo "No connection"
        # Add your command or alias for no connection here
    fi
}

function npmOnWeb() {
    if [[ "$(nmcli -t -f DEVICE,STATE dev)" == *"eno1:connected"* ]]; then
        # Alias for Ethernet connection
        echo "!!__Running npm on Ethernet connection__!!"
        npm run dev -- -H 192.168.29.10
        # Add your command or alias for Ethernet here    
    elif [[ "$(nmcli -t -f DEVICE,STATE dev)" == *"wlo1:connected"* ]]; then
        # Alias for Wi-Fi connection
        echo "!!__Running npm on WIFI connection__!!"
        npm run dev -- -H 192.168.29.10
        # Add your command or alias for Wi-Fi here
    else
        echo "No connection"
        # Add your command or alias for no connection here
    fi
}
# This Util Function returns the id of new Opend window of a application 
# $1 = application name 
function openNewWindow() {
    existing_windows=$(wmctrl -l | grep "$1" | awk '{print $1}')
    # echo $1
    # echo $existing_windows
    new_window=null

    # Open Applications
    if [[ "$1" == "Visual Studio Code" ]]; then
        code &
    elif [[ "$1" == "Edge" ]]; then
        microsoft-edge
    else
        echo "Enter Valid Application Name"
        exit 1
    fi

    # Wait for the application to start
    COUNTER=0
    while true; do
        let COUNTER=COUNTER+1
        current_windows=$(wmctrl -l | grep "$1" | awk '{print $1}')
        # echo $current_windows
        if [[ "$current_windows" != "$existing_windows" ]]; then
            new_window=$(comm -23 <(echo "$current_windows" | sort) <(echo "$existing_windows" | sort))
            break
        fi
        if (( COUNTER == 20 )); then
            echo "No $1 window was created within 20 seconds"
            break
        fi
        sleep 1
    done
    echo $new_window
}

function nextSetup() {
    # Create new  Windows
    vscode_window_01=$(echo $(openNewWindow "Visual Studio Code") | grep -o -E '0x[0-9a-fA-F]+')
    vscode_window_02=$(echo $(openNewWindow "Visual Studio Code") | grep -o -E '0x[0-9a-fA-F]+')
    edge_window_dump=$(echo $(openNewWindow "Edge") | grep -o -E '0x[0-9a-fA-F]+')
    edge_window_01=$(echo $(openNewWindow "Edge") | grep -o -E '0x[0-9a-fA-F]+')
    edge_window_02=$(echo $(openNewWindow "Edge") | grep -o -E '0x[0-9a-fA-F]+')


    # echo $vscode_window_01
    # echo $vscode_window_02
    # echo $edge_window_dump
    # echo $edge_window_01
    # echo $edge_window_02
    
    # close the dummy Edge Window
    wmctrl -i -c $edge_window_dump 
    # Move Edge to workspace 1
    wmctrl -i -r $edge_window_01  -t 0
    wmctrl -i -r $edge_window_01  -b add,maximized_vert,maximized_horz
    # Move VS Code to workspace 2
    wmctrl -i -r $vscode_window_01  -t 1
    wmctrl -i -r $vscode_window_01  -b add,maximized_vert,maximized_horz
    # Move VS Code to workspace 4
    wmctrl -i -r $edge_window_02  -t 2
    wmctrl -i -r $edge_window_02  -b add,maximized_vert,maximized_horz
    # Move VS Code to workspace 3
    wmctrl -i -r $vscode_window_02  -t 3
    wmctrl -i -r $vscode_window_02  -b add,maximized_vert,maximized_horz

}
