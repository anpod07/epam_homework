#!/bin/bash
# bash l3.sh 7 1 5 7 4 3 6
len=$#; j=0; n1=0; n2=1; res=""
for i in "$@"; do
 ((j++))
 echo "Arg$j: $i"
 n1=$i
 if [ $n2 -ne 0 ]
  then res="$res $((n1+n2)) "
 fi
 n2=$i
done
res="$res $(($1+${!len}))"
echo $res
