##!/usr/bin/env bash

if [ $(gsettings get org.gnome.desktop.peripherals.touchpad send-events) == "'enabled'" ]; then
  echo "Switching off"
  gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled
  notify-send --app-name="System" "Touchpad Disabled" "To enable it again, press SUPER+T"
else
  echo "Switching on"
  gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
  notify-send --app-name="System" "Touchpad Enabled" "To disable it again, press SUPER+T"
fi
