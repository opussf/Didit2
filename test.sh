#!/bin/sh
targetDir="/Applications/World of Warcraft/Interface/AddOns/Didit/"
files="Didit.lua DiditData.lua Didit.toc Didit.xml"

for f in $files 
do
diff "$targetDir"$f $f
cp -v $f "$targetDir"
done

