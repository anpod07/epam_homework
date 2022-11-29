#!/usr/bin/env bash
# scan hosts
iprange='192.168.1.0/24'

Help()
{
 echo "Syntax: [-target <IP> | -all]"
 echo "-target: scan Target host[s]"
 echo "-all:    display IPs of All hosts"
 exit 2
}

Target()
{
 if [ -z "$1" ]; then echo "no target setted"; exit 2; fi
 arr=("$@")
 unset "arr[0]"
 Parm=`echo ${arr[@]}`
 nmap -T4 -p 1-1024 $Parm
}

All()
{
 nmap -T4 -p 1-1024 $iprange | grep 'scan report for' | awk '{print $5,$6}'
}

if [ -z "$1" ]; then Help; fi
case "$1" in
 -target) Target $@;;
    -all) All;;
       *) echo "input error"
          Help
          exit 2
          ;;
esac
