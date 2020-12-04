#!/bin/bash

# Scans host and ports in a loop every 15 seconds

  if [[ -z $1 || -z $2 ]]; then
    echo "Usage: $0 <host> <port, ports, or port-range>"
    return
  fi

  host=$1
  ports=()
  case $2 in
    *-*)
      IFS=- read start end <<< "$2"
      for ((port=start; port <= end; port++)); do
        ports+=($port)
      done
      ;;
    *,*)
      IFS=, read -ra ports <<< "$2"
      ;;
    *)
      ports+=($2)
      ;;
  esac

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

while true; do
echo $(date)
  for port in "${ports[@]}"; do
    timeout 2 bash -c "</dev/tcp/$host/$port" &&
      echo "${red}port $host:$port is open${reset}" ||
      echo "${green}port $host:$port is closed${reset}"
  done
  sleep 15
done
