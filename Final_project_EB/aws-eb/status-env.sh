if grep -q 'ERROR:' <<< $(eb status)
 then echo 1
 else echo 2
fi

#eb list
eb status
#eb config --display > 1.log
