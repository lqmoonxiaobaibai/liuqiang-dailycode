#!/bin/bash
read -p "please input your word:" string
[ -z "$string" ] && { echo "please input again!" ; exit 30;}
echo $string | awk '{i=0;while(i<=NF){if(length($i)<=6)print $i;i++}}' 
