#!/bin/bash

USER=$(whoami)
cd /Users/${USER}/Library/Application\ Support/Steam/Steam.AppBundle/Steam/Contents/MacOS/public; ls *.res | while read line ; do file=$(echo $line | tr '[:upper:]' '[:lower:]'); mv $line $file; done
cd /Users/${USER}/Library/Application\ Support/Steam/Steam.AppBundle/Steam/Contents/MacOS/steam/cached/; ls *.res | while read line ; do file=$(echo $line | tr '[:upper:]' '[:lower:]'); mv $line $file; done
cd /Users/${USER}/Library/Application\ Support/Steam/Steam.AppBundle/Steam/Contents/MacOS/friends; ls *.res | while read line ; do file=$(echo $line | tr '[:upper:]' '[:lower:]'); mv $line $file; done
cd /Users/${USER}/Library/Application\ Support/Steam/Steam.AppBundle/Steam/Contents/MacOS/graphics; ls *.tga | while read line ; do file=$(echo $line | tr '[:upper:]' '[:lower:]'); mv $line $file; done
cd /Users/${USER}/Library/Application\ Support/Steam/Steam.AppBundle/Steam/Contents/MacOS/servers; ls *.tga | while read line ; do file=$(echo $line | tr '[:upper:]' '[:lower:]'); mv $line $file; done
