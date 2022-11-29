#!/usr/bin/env bash
# create tar archive
hpth="$2"
fpth="$1"
status="added"

Help()
{
 echo "Syntax: Archive_file_path Target_dir[file]"
 exit 2
}

if [ -z "$1" ]; then Help; exit 2; fi
if [ -f $fpth ]; then echo "file exist"; status="replaced"; fi

if [ -d $hpth ] || [ -f $hpth ]
 then
  tar cf $fpth $hpth
  echo `date` :: $fpth :: $status >> l3.log
 else
  echo "error"
fi
