#!/bin/bash

# Author: Mark Hanson
# Description: BASH script that outputs AutoSys job definitions and 
#              adds their last reported status via status attribute 
# Requires BASH 4 (echo $BASH_VERSION)

usage() { echo "Usage: `basename $0` [-j job_name] [-h]" 1>&2; exit 1; }

declare -A status_map

status_map["AC"]="ACTIVATED"
status_map["FA"]="FAILURE"      `: Valid`
status_map["IN"]="INACTIVE"     `: Valid`
status_map["NE"]="ON_NOEXEC"    `: Valid`
status_map["OH"]="OH_HOLD"      `: Valid`
status_map["OI"]="ON_ICE"       `: Valid`
status_map["PE"]="PEND_MACH"
status_map["QU"]="QUE_WAIT"
status_map["RE"]="RESTART"
status_map["RU"]="RUNNING"
status_map["RW"]="RESWAIT"
status_map["ST"]="STARTING"
status_map["SU"]="SUCCESS"      `: Valid`
status_map["SP"]="SUSPENDED"
status_map["TE"]="TERMINATED"   `: Valid`

if (($# == 0)); then
  usage
fi

while getopts ":hj:J:" opt; do
  case "$opt" in
      j)
        job_name=${OPTARG}
        ;;
      J)
        job_name=${OPTARG}
        ;;
      h)
        usage
        ;;
      :) echo "Missing arg for -$OPTARG"; exit 1 ;;
      \?) echo "Unknown arg -$OPTARG"; exit 1 ;;
  esac
done

  # Array of job names
job_array=`autorep -J $job_name | awk 'NR>3 {print $1}'`
if [ -z "job_array" ]; then
  printf "No jobs found!\n" >&2
  exit 1
fi

  # For each job, get its status then add to definition while printing
for job in ${job_array[@]}
do
  job_status=`autorep -J $job -s | grep $job | awk '{print $6}'`
  if [[ -z "${status_map[${job_status}]}" ]]; then
    printf "$job_status not found. Checking again...\n" >&2
      # sometimes status is the 5th field
    job_status=`autorep -J $job -s | grep $job | awk '{print $5}'`
      # check it again
    if [[ -z "${status_map[${job_status}]}" ]]; then
      printf "$job_status still not found.\n" >&2
        # sometimes status is the 4th field
      job_status=`autorep -J $job -s | grep $job | awk '{print $4}'`
    fi
else
  autorep -J $job -q
  printf "status: ${status_map[${job_status}]}\n"
fi
done
