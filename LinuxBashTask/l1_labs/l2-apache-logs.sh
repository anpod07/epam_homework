#!/usr/bin/env bash
# parse apache logs
#alog='l2-apache-logs.txt'
alog='l2-example_log.log'
res='l2-result.txt'
# 1. From which ip were the most requests?
echo -n "The most requested IP: " > $res
awk '{pop[$1]+=1} END {for (i in pop) {print i " :: " pop[i] " requests"}}' $alog | sort -nrk3 | head -1 >> $res
echo >> $res
# 2. What is the most requested page?
echo -n "The most requested page: " >> $res
awk '{pop[$7]+=1} END {for (i in pop) {print i " :: " pop[i] " requests"}}' $alog | sort -nrk3 | head -1 >> $res
echo >> $res
# 3. How many requests were there from each ip?
echo "Requests from each IP:" >> $res
awk '{pop[$1]+=1} END {for (i in pop) {print i " :: " pop[i] " requests"}}' $alog | sort -nrk3 >> $res
echo >> $res
# 4. What non-existent pages were clients referred to?
echo "Non-existent pages:" >> $res
awk '$9!=200' $alog >> $res
echo >> $res
# 5. What time did site get the most requests?
echo -n "Time with the most requests, by minutes: " >> $res
awk '{print $4}' $alog | tr -d "[" | awk -F: 'OFS=":" {print $1,$2,$3}' | awk '{pop[$1]+=1} END {for (i in pop) {print i " :: " pop[i] " requests"}}' | sort -nrk3 | head -1 >> $res
echo >> $res
# 6. What search bots have accessed the site? (UA + IP)
echo "Search bots (UA + IP):" >> $res
grep -i "bot" $alog | awk '{print $(NF-1),$1}' | tr -d ";" | sort -u >> $res


#46.29.2.62 - - [30/Sep/2015:00:17:01 +0300] "GET /cats HTTP/1.0" 200 146 "-" "Wget/1.12 (linux-gnu)"^M
#46.29.2.62 - - [30/Sep/2015:00:20:01 +0300] "GET /flowers HTTP/1.0" 200 146 "-" "Wget/1.12 (linux-gnu)"^M
#46.29.2.62 - - [30/Sep/2015:00:22:01 +0300] "GET /dresses HTTP/1.0" 200 146 "-" "Wget/1.12 (linux-gnu)"^M
