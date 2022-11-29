#!/bin/bash
# bash l4.sh 5 6 1 3 9
func1 () { res=$(($1*$1)); }; func2 () { func1 $1; echo $(($res+1)); }; for i in "$@"; do func2 $i; done
