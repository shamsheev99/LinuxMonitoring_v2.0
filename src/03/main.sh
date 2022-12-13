#!/bin/bash
PATH_TO_SCRIPT=`dirname $0`"/"
function delete {
    dfiles=`cat $PATH_TO_SCRIPT/deleted_files.txt 2> /dev/null | awk '{print $1}'`
    for z in $dfiles
    do
        test -d $z 2> /dev/null && sudo rm -rf $z 2> /dev/null
        local x=`dirname $z`
        test -f $z 2> /dev/null && sudo rm -rf $x 2> /dev/null
    done
}
if [[ $# != 1 ]]; then
    echo "Enter the clean type: 1 - on path in logs file, 2 - one time in logs file, 3 - on mask"
    read param
    else param=$1
fi
if [[ -d ../02/logs_file.txt ]] 
then
    echo "../02/logs_file.txt: No such file or directory"
else 
    touch $PATH_TO_SCRIPT/deleted_files.txt 
    declare -x name_log=`cat ../02/logs_file.txt | awk '{print $1}' | awk '{print $NF}' | awk -F "." '{print $1}'` 
    case $param in
        1)
            dfiles="$(cat ../02/logs_file.txt | awk '{print $1}')"
            for i in $dfiles
            do
                echo $i >> $PATH_TO_SCRIPT/deleted_files.txt 
            done
            delete
            #rm ../02/logs_file.txt 
            ;;
        2)
            echo "Insert start yime: YYYY-mm-DD HH:MM"
            read startDate
            echo "Insert end time: YYYY-mm-DD HH:MM"
            read endDate
            suitable_files=$name_log
            deleted+=`sudo find / -newermt "$startDate" ! -newermt "$endDate"  2>/dev/null | sort -r`
            dfiles=`cat ../02/logs_file.txt | awk '{print $1}'`
            touch $PATH_TO_SCRIPT/tmp_logs.txt
            for j in $dfiles
            do
                echo $j >> $PATH_TO_SCRIPT/tmp_logs.txt
            done
            count=`echo "$deleted" | grep -f "tmp_logs.txt" | wc -l`
            for((m=1; m<=$count; m++))
            do
                echo `echo "$deleted" | grep -f "tmp_logs.txt" | head -$m | tail +$m `>> $PATH_TO_SCRIPT/deleted_files.txt 
            done
            delete
            rm -f $PATH_TO_SCRIPT/tmp_logs.txt
            # rm ../02/logs_file.txt 
            ;;

        # По маске имени
        3)
            echo "Enter tha mask: abcd_DDMMYY"
            read mask_name
            date_name=`echo $mask_name | awk -F "_" '{printf $2}'`
            mask_name=`echo $mask_name | awk -F "_" '{printf $1}'`
            length_name=`expr length $mask_name`
            NAME="([^\s]*\/)"
            for((v = 1; v <= $length_name; v++))
            do
                arr[$v]=
                arr[$v]=`expr substr $mask_name $v 1 2> /dev/null`
                NAME+="${arr[$v]}+"
            done
            NAME+="_$date_name/"
            v=1
            count=`sudo find / -type d | egrep "*$NAME*" | wc -l`
            for((v = 1; v <= $count; v++)) 
            do
                echo `sudo find / -type d | egrep "*$NAME*" | head -$v | tail +$v` >> $PATH_TO_SCRIPT/deleted_files.txt
            done
            delete
            # rm ../02/logs_file.txt 
            ;;

        *) echo "ERROR!";;
    esac
fi