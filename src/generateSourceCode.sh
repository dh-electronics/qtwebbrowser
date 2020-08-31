#!/bin/bash
cd $1
echo "Generate Source Code"
python3 -m cogapp -d -o globalsettings.cpp  globalsettings.cpp.cog
python3 -m cogapp -d -o globalsettings.h  globalsettings.h.cog
