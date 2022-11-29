#!/bin/bash
# bash l1.sh 3 6 9
# bash l1.sh hello "hello world" "pie is lie" "keep calm and procrastinate"
len=$#
echo $len
if [ $len -lt 2 ]
 then echo "List of args: $@"
 elif [ $len -gt 2 -a $len -lt 4 ]
  then echo "Last arg: ${!len}"
 else echo "Invalid numbers of args"
fi
