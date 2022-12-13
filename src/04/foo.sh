#!/bin/bash

# IP (любые корректные, т.е. не должно быть ip вида 999.111.777.777)
# Коды ответа (200, 201, 400, 401, 403, 404, 500, 501, 502, 503)
# Методы (GET, POST, PUT, PATCH, DELETE)
# Даты (в рамках заданного дня лога, должны идти по увеличению)
# URL запроса агента
# Агенты (Mozilla, Google Chrome, Opera, Safari, Internet Explorer, Microsoft Edge, Crawler and bot, Library and net tool)
function random {
    local min=$1
    local max=$2
    local number=$(($min-1))
    while [[ $number -lt $min || $number -gt $max ]]
    do
        local number=$RANDOM
    done
    echo $number
}

function get_url {
    local number=$(random 4 10)
    local length_url=$(random 2 5)
    local URL=`head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c $number`".com"
    for((i=0; i<$length_url; i++))
    do
        local number=$(random 4 10)
        local URL+="/"`head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c $number`""
    done
    URL+=".html"
    echo "http://"$URL
}

function get_method {
    local METHODS=(GET POST PUT PATCH DELETE)
    local number=$(random 0 4)
    echo ${METHODS[$number]}
}

function get_UA {
    local USER_AGENT=("Firefox/47.0" "Chrome/51.0.2704.103" "Opera/9.60" "Safari/604.1" \
    "IEMobile/9.0" "Edg/91.0.864.59" "Googlebot/2.1" "PostmanRuntime/7.26.5")
    local number=$(random 0 7)
    echo ${USER_AGENT[$number]}

}

function get_code {
    local CODES=(200 201 400 401 403 404 500 501 502 503)
    local number=$(random 0 9)
    echo ${CODES[$number]}
}

function get_ip {
    local ip=$(random 0 255)
    for((i=0; i<3; i++))
    do
        local ip+="."$(random 0 255)
    done
    echo $ip
}

function get_time {
    local hour=$(random 0 23)
    local minute=$(random 0 59)
    local second=$(random 0 59)
    if [[ $hour -lt 10 ]]
    then local hour="0"$hour
    fi
    if [[ $minute -lt 10 ]]
    then local minute="0"$minute
    fi
    if [[ $second -lt 10 ]]
    then local second="0"$second
    fi
    local date=$hour":"$minute":"$second
    echo $date
}

# echo $(get_ip)
# touch test.sh
# chmod +x test.sh
# ./test.sh
#CODES=(200, 201, 400, 401, 403, 404, 500, 501, 502, 503)
#CODES_ANSWERS=("200 OK" "201 Created" "400 Bad Request" "401 Unauthorized" "403 Forbidden" \
#"404 Not Found" "500 Internal Server Error" "501 Not Implemented" "502 Bad Gateway" "503 Service Unavailable")


#head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c 9
#http user-agent
#Mozilla "Firefox/47.0"
#Google Chrome "Chrome/51.0.2704.103"
#Opera "Opera/9.60"
#Safari "Safari/604.1"
#Internet Explorer "IEMobile/9.0"
#Microsoft Edge "Edg/91.0.864.59"
#Crawler and bot "Googlebot/2.1"
#Library and net tool "PostmanRuntime/7.26.5"

#CODES ANSWER
#200 OK
#201 Created
#400 Bad Request
#401 Unauthorized
#403 Forbidden
#404 Not Found
#500 Internal Server Error
#501 Not Implemented
#502 Bad Gateway
#503 Service Unavailable