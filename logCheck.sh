#!/bin/bash
# Bash script to search log files
# Source function file

source ./fun.sh

 # Directories & File list
 LOGPATH=/home/ubuntu/LOG
 TEMPLOG=/home/ubuntu/CHECK_LOG/tempLog.log
 LOG_KO=/home/ubuntu/CHECK_LOG/log_KO.log
 LOG_FINAL=/home/ubuntu/CHECK_LOG/log_final.log
 LINES_EXTRACT=/home/ubuntu/CHECK_LOG/lines_extract.log
 LINES_FINAL=/home/ubuntu/CHECK_LOG/lines_final.log
function_TSOID
