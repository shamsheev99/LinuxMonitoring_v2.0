#!/bin/bash
source foo.sh

function add_zero {
    local number=$1
    if [[ $number -lt 10 ]]
    then number="0"$number
    fi
    echo $number
}

i=0
echo "pls wait i'm working now :)"
for i in {0..4}
do
    touch "$(($i+1)).log"
    touch "$(($i+1))_tmp.log"
    echo -ne "" > "$(($i+1)).log"
    echo -ne "" > "$(($i+1))_tmp.log"
    count_writes=$(random 100 1000)
    for((j=0; j<$count_writes; j++))
    do
        date=`date +%_d`
        date=$(($date+$i))
        date=$(add_zero $date)
        date_add="/"`date | awk '{print $3"/"$4":"}'`"$(get_time)"" "`date +%z`"]"
        date="["$date$date_add
        echo "`get_ip` "-" "-" $date \"`get_method` `get_url`\" `get_code` "-" "-" \"`get_UA`\"" | sort -k2 >> "$(($i+1))_tmp.log"
    done
    count=`cat $(($i+1))_tmp.log | sort -k2 | wc -l`
    for((z=1; z<=$count; z++))
    do
        echo `cat $(($i+1))_tmp.log | sort -k2 | head -$z | tail +$z` >> "$(($i+1)).log"
    done
    rm -rf "$(($i+1))_tmp.log"
done
echo "Completed"

