#!/bin/sh

#kill any old versions that exist
if [ -d "/Library/InputManagers/MultiClutchManager/" ]; then
   rm -rf "/Library/InputManagers/MultiClutchInputManager/"
fi
#copy the input manager and make sure permissions are ok
echo "$(dirname "$0")"
cp -R "$(dirname "$0")/MultiClutchInputManager" "/Library/InputManagers/"
chown -R root:admin "/Library/InputManagers/"
chmod -R go-w "/Library/InputManagers/"
osascript "$(dirname "$0")/launch_multiclutch.scpt"
