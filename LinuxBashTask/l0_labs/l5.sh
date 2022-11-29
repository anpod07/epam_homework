#!/bin/bash
# test variant
#greet() { for i in seq$1; do echo Hello $i done } greet "2 5"

# my variant
greet() { for i in `seq $1`; do echo Hello $i; done }; greet "2 5"
