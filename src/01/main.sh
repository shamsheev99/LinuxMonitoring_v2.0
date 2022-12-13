#!/bin/bash
cd $(dirname $0)
ERROR_FLAG=0
#check input parameters
if [ $# != 6 ];
then
    echo "Error: Input 6 parametr"
    ERROR_FLAG=1
else
    declare -x ABS_PATH=$1
    if ! [ -d $ABS_PATH ]; then
        echo "Error <FIRST PAR>: <$ABS_PATH> not directory, enter /<directory name>/"
        ERROR_FLAG=1
    else
        :
    fi
    declare -x COUNT_DIR=$2
    if [[ $COUNT_DIR =~ ^[0-9] ]] && [[ $COUNT_DIR -gt 0 ]]
    then
        :
    else
        echo "Error <SECOND PAR: <$COUNT_DIR> incorrect input: ^[0-9]+$"
        ERROR_FLAG=1
    fi
    declare -x ALPHABET_DIR=$3
    LENGTH_DIR_ALPHABET=`expr length $ALPHABET_DIR`
    if [[ $LENGTH_DIR_ALPHABET -le 7 ]] && [[ $ALPHABET_DIR =~ ^[a-z]+$ ]]
    then
        :
    else 
        echo "Error <THIRD PAR: <$ALPHABET_DIR> incorrect input:^[0-7]"
        ERROR_FLAG=1
    fi
    declare -x COUNT_FILES=$4
    if [[ $COUNT_FILES =~ ^[0-9]+$ ]]
    then 
        :
    else
        echo "Error <FOURTH PAR>: <$COUNT_FILES> incorrect input:^[0-9]+$"
        ERROR_FLAG=1
    fi
    if [[ $5 =~ ^[a-z]+[.]+[a-z]+$ ]]
    then 
        declare -x ALPHABET_FILE="${5%.[^.]*}"
        LENGTH_FILE_ALPHABET=`expr length $ALPHABET_FILE`
        declare -x ALPHABET_EXT="${5##*.}"
        LENGTH_EXT_ALPHABET=`expr length $ALPHABET_EXT`
        if [[ $ALPHABET_FILE_ALPHABET -le 7 && $ALPHABET_EXT_ALPHABET -le 3 ]]
        then
            :
        else 
            echo "Error <FIFTH PAR>: <$5> incorrect input: 7[Aa-Zz].3[Aa-Zz]"
            ERROR_FLAG=1
        fi
    else
        echo "Error <FIFTH PAR>: <$5> incorrect input: 7[Aa-Zz].3[Aa-Zz]"
        ERROR_FLAG=1
    fi
    declare -x SIZE_FILE=`echo $6 | egrep -o ^[0-9+$]*`
    if [[ $SIZE_FILE -le 0 ]] || [[ $SIZE_FILE -gt 100 ]] 
    then
        echo "Error <SIXTH PAR> : <$SIZE_FILE> is incorrect input: [0-9]&&<=100"
    else
        :
    fi
fi
if [[ ERROR_FLAG -eq 0 ]]
then
    chmod +x processing.sh
    ./processing.sh
else
    :
fi
