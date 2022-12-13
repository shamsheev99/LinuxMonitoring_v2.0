#!/bin/bash

file="../04/1.log ../04/2.log ../04/3.log ../04/4.log ../04/5.log"

function code_sort {
    local count=`cat $file | wc -l`
    for((i=1;i<=$count;i++))
    do
        echo `cat $file | sort -k8 | head -$i | tail +$i`
    done
}

function ip_sort {
    local files="$1"
    local count=`cat $files | awk -F "-" '{print $1}' | sort -u | wc -l`
    echo $count
    for((i=1;i<=$count;i++))
    do
        echo `cat $files | awk -F "-" '{print $1}' | sort -u | head -$i | tail +$i`
    done
}

function error_code_find {
    local count=`cat $file | wc -l`
    for((i=1;i<=$count;i++))
    do
        local code_log=`cat $file | awk '{print $8}' | head -$i | tail +$i`
        if [[ $code_log -ge 400 ]]
        then
            echo `cat $file | head -$i | tail +$i`
        fi
    done
}

if [[ $# != 1 ]] || [[ ! $1 =~ ^[1-4] ]]
then 
    echo "ERROR"
    exit 1
fi

case $1 in
    1)  touch sort_by_code.txt
        echo -ne "" > sort_by_code.txt
        code_sort | tee sort_by_code.txt
        
        ;;
    2)  touch sort_by_uniq_ip.txt
        echo -ne "" > sort_by_uniq_ip.txt
        ip_sort "$file" | tee sort_by_uniq_ip.txt

        ;;
    3)  touch error_code.txt
        echo -ne "" > error_code.txt
        error_code_find | tee error_code.txt
        ;;
    4)  touch sort_by_uniq_ip_error_code.txt
        echo -ne "" > sort_by_uniq_ip_error_code.txt
        touch error_code.txt
        echo -ne "" > error_code.txt
        error_code_find > error_code.txt
        ip_sort error_code.txt | tee sort_by_uniq_ip_error_code.txt
        ;;
esac