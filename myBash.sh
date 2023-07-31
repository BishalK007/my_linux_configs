#______________My Commands _______________
source /usr/share/git-core/contrib/completion/git-prompt.sh
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
