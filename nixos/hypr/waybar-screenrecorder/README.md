# waybar-screenrecorder

waybar module to record your screen.


# Requirements


Requires [wf-recorder](https://github.com/ammen99/wf-recorder).


Put the following in `$HOME/.config/waybar/config`:

```
"custom/screenrecorder": {
    "exec": "$HOME/.config/waybar/waybar-screenrecorder/screenrecorder status",
    "interval": "once",
    "signal": 1,
    "return-type": "json",
    "tooltip": true,
    "format": "{}",
    "on-click": "$HOME/.config/waybar/waybar-screenrecorder/screenrecorder toggle fullscreen",
    "on-click-right": "$HOME/.config/waybar/waybar-screenrecorder/screenrecorder toggle region"
},
```

