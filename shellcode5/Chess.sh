#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                Chess.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

PS3=`echo -e "\033[1;35mPlease choose the chess high and wide (eg:wide=2high)number:\033[0m" `

select chess in once double triple quadruple 
do
       case $REPLY in 
       1) 
                echo "chess is once!!!"
                cell=1
                break
                ;;
       2) 
                echo "chess is double!!!"
                cell=2
                break
                ;;
       3)
                echo "chess is triple!!!"
                cell=3
                break
                ;;
      4)
                echo "chess is quadruple!!!"
                cell=3
                break
                ;;        
      esac
done




PS3=`echo -e "\033[1;34mPlease choose the chess  color number:\033[0m"`

select chess in black-white red-blue 
do
       case $REPLY in
       1)
                echo "chess color  is black-white!!!"
                color1=40
                color2=47
                break
                ;;
       2)
                echo "chess color  is red-blue!!!"
                color1=41
                color2=46
                break
                ;;
      esac
done


high=$cell
wide=$[$cell*2]

red_color () {

      if [ "$1" == "-r"  ];then
                echo -e "\033[1;${color2}m`printf "%${wide}s"`\033[0m\c"
      else
                echo -e "\033[1;${color1}m`printf "%${wide}s"`\033[0m\c"
      fi
  
}

for i in {1..8};do
    if [ $[i%2] -eq 1 ];then
          for j in `seq 1 "$high"`;do
                 for k in {1..8};do
                          if [ $[k%2] -ne 0 ];then
                                    red_color                            
                          else
                                    red_color -r
                          fi
                  done
                  echo  
                  
          done
    else
          for m in `seq  1 $high`;do
                  for n in {1..8};do
                          if [ $[n%2] -ne 0 ];then
                                   red_color -r
                          else
                                   red_color
                          fi
                         
                  done
                  echo  
                  
          done
     fi
done

