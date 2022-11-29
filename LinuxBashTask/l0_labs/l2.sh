#!/bin/bash
# bash l2.sh 1 2 3 4 5
len=$#
i=0; sum=0
for i in "$@"; do
 sum=$(($sum+$i))
done
echo "Number of args: $len"
echo "Sum: $sum"
echo "Average: $(($sum/$len))"
