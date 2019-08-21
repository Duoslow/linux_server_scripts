#!/bin/bash
sa=$(sudo find /var/lib/jellyfin/metadata/library/ -name *.srt -exec iconv -f ISO-8859-9 -t UTF-8 {} -o $sa /{} \;
)
echo "$sa"