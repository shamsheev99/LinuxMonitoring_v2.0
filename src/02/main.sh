#!/bin/bash
start_time=`date +%s%N`
cd $(dirname $0)
ERROR_FLAG=0

function rand {
    local max_number=$1
    local NUMBER=-1
    while [[ $NUMBER -gt $max_number ]] || [[ $NUMBER -le 0 ]];
    do
        local NUMBER=$RANDOM
    done
    echo $NUMBER
}

function gen_path {
    local MAX_COUNT_DIR=`find / -type d 2> /dev/null | grep -v -e bin -e sbin -e Permission | wc -l `
    local NUMBER=$(rand $MAX_COUNT_DIR)
    #check_dir=`dirname DIR_TO_DDOS`
    # tmp_check=
    # tmp_check=`ls -l $check_dir 2> /dev/null | grep root`
    local DIR_TO_DDOS=`find / -type d 2> /dev/null | grep -v -e bin -e sbin -e Permission | head -$NUMBER | tail +$NUMBER 2> /dev/null`
    # touch "$DIR_TO_DDOS/test.txt" 2> /dev/null
    # if [[ -e "$DIR_TO_DDOS/test.txt" ]]
    # then 
        echo $DIR_TO_DDOS
    #     rm -rf "$DIR_TO_DDOS/test.txt"
    # else 
        
    # fi
}

#check input parameters
if [ $# != 3 ];
then
    echo "Error: Input 3 parametr"
    ERROR_FLAG=1
else
    declare -x ALPHABET_DIR=$1
    declare -x LENGTH_DIR_ALPHABET=`expr length $ALPHABET_DIR`
    if [[ $LENGTH_DIR_ALPHABET -le 7 ]] && [[ $ALPHABET_DIR =~ ^[a-z]+$ ]]
    then
        :
    else 
        echo "Error <FIRST PAR: <$ALPHABET_DIR> incorrect input:^[0-7]"
        ERROR_FLAG=1
    fi
    if [[ $2 =~ ^[a-z]+[.]+[a-z]+$ ]]
    then 
        declare -x ALPHABET_FILE="${2%.[^.]*}"
        declare -x LENGTH_FILE_ALPHABET=`expr length $ALPHABET_FILE`
        declare -x ALPHABET_EXT="${2##*.}"
        declare -x LENGTH_EXT_ALPHABET=`expr length $ALPHABET_EXT`
        if [[ $ALPHABET_FILE_ALPHABET -le 7 && $ALPHABET_EXT_ALPHABET -le 3 ]]
        then
            :
        else 
            echo "Error <SECOND PAR>: <$2> incorrect input: 7[Aa-Zz].3[Aa-Zz]"
            ERROR_FLAG=1
        fi
    else
        echo "Error <SECOND PAR>: <$2> incorrect input: 7[Aa-Zz].3[Aa-Zz]"
        ERROR_FLAG=1
    fi
    declare -x SIZE_FILE=`echo $3 | egrep -o ^[0-9+$]*`
    if [[ $SIZE_FILE -le 0 ]] || [[ $SIZE_FILE -gt 100 ]]
    then
        echo "Error <THIRD PAR> : <$SIZE_FILE> is incorrect input: [0-9]&&<=100"
        ERROR_FLAG=1
    else
        :
    fi
fi
if [[ ! $ERROR_FLAG -eq 1 ]]
then
    echo "Script start time" - `date +%F" "%H:%M" "%S`s
    slash=\/
    FREE_SPACE_MB=$(df / |  head -2 | tail +2 | awk '{printf("%d", $4)}')
    chmod +x ./processing.sh
    touch logs_file.txt
    while [[ ERROR_FLAG -eq 0 ]] && [[ FREE_SPACE_MB -ge $((1048576+$(($SIZE_FILE*1024)))) ]]
    do
        
        PATH_TO_DDOS=
        PATH_TO_DDOS=$(gen_path)
        if [ -e $PATH_TO_DDOS$slash ]
        then
            declare -x COUNT_DIR=$(rand 100)
            declare -x COUNT_FILES=$(rand 100)
            declare -x ABS_PATH=$PATH_TO_DDOS
            #echo $PATH_TO_DDOS
            ./processing.sh
            FREE_SPACE_MB=$(df / |  head -2 | tail +2 | awk '{printf $4}')
        fi
    done
    end_time=`date +%s%N`
    echo "Script finish time" - `date +%F" "%H:%M" "%S`s
    result_time=$(($end_time-$start_time))
    seconds=$(($result_time/1000000000))
    if [[ $result_time -lt 60 ]]
    then
        minuts=0
    else
        minuts=$(($seconds/60))
        seconds=$(($seconds%60))
    fi
fi
