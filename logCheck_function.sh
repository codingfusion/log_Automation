
# Function to search another string after a match is found...
function_input()
 {
   read -p "Do you want to search another string? (y/n) : " OPTION
   if [[ ! -z $OPTION ]]; then
    while [[ ! -z $OPTION ]]
     do
      if [[ $OPTION == 'N' || $OPTION == 'n' ]]; then
          echo "You chose to quit..Bye!!"
          exit 0
      elif [[ $OPTION == 'Y' || $OPTION == 'y' ]]; then
       while [[ $OPTION == 'Y' || $OPTION == 'y' ]]
          do
            read -p "Please enter String to search in log file and press [ENTER]: " STRING_SEARCH_AGAIN
            IF_STRING_EXIST_AGAIN=$(grep -iwa2 "$STRING_SEARCH_AGAIN" $LOG_FINAL)
            WORDS_AGAIN=$(echo $IF_STRING_EXIST_AGAIN | wc -w)
            if [[ $WORDS_AGAIN == 0 ]]; then
              echo "String "$STRING_SEARCH_AGAIN" does not exist"
              function_input
            else
              echo $IF_STRING_EXIST_AGAIN
              echo  "Provided Input string found"
              read -p "Do you want to search another string? (y/n) : " OPTION
            fi
          done
      else
       echo "Please enter Y or N and try again"
       function_input
      fi
     done
   else
    echo "Please provide an option to proceed: "
    function_input
   fi
 }


# Function to take TSOID as input and perform relevant operation on it.
 function_TSOID()
{
 # Take TSOID as input from user
  read -p "Enter TSO ID: " TSOID
   if [[ ! -z $TSOID ]]; then
    while [[ ! -z $TSOID ]];
     do
 	 echo "Searching TSOID " $TSOID

 	 # Find the TSOID id as string in specified directory
 	 arr=( $(find $LOGPATH -type f -name "*.log" -exec grep -lw $TSOID {} \; | sort -r) )

 	 # Print all log file names on STD output for user to choose from and storing it into a temp log.
 	 if [ ${#arr[@]} -eq 0 ]; then
 		echo "No matches found for " $TSOID
 		exit 0
 	 else
 		echo "TSOID "$TSOID "found in following logs: "
 		arr+=('Quit')
 		PS3='Please enter a number from above list: '
 		select opt in "${arr[@]}"
 		do
 			case $opt in
 				"${arr[-1]}")
 					echo "Bye"
 					exit 0
 					;;
 				*)
 					cat $opt > $TEMPLOG
 					echo 'Log ' $opt 'succesfully saved at path ' $TEMPLOG
 					break
 					;;
 					esac
 	       done
 	 fi

 	  # Extracting desired TSOID from actual log.
 	  echo 'Now extracting desired TSOID '$TSOID ' from tempLog'
          TIMESTAMP="2020 Oct 21 08:34:05:523 GMT +2"
          COUNT_TIME=$(grep -c "$TIMESTAMP" $TEMPLOG)   #TIMESTAMP count
          echo $COUNT_TIME
          for (( i=1; i <= $COUNT_TIME; i++ ))
          do
             echo "loop executed"
 	     grep -nw "$TIMESTAMP" $TEMPLOG | awk -F: 'NR==1 {printf "%d ", $1}; NR==2 {print $1}' > $LOG_KO
             cat $LOG_KO
 	     LINE1=$(awk '{print $1}' $LOG_KO)
 	     LINE2=$(awk '{print $2}' $LOG_KO)
 	     awk -v f=$LINE1 -v l=$LINE2 'NR>=f && NR<=l' $TEMPLOG > $LINES_EXTRACT
             echo
            # cat $LINES_EXTRACT
             awk -v f=$LINE1 -v l=$LINE2 'NR>=f && NR<=l-1' $LINES_EXTRACT > $LINES_FINAL
             echo 
            # cat $LINES_FINAL
echo "LINE2:" $LINE2
           grep -nw "$TIMESTAMP" $TEMPLOG | awk -F: 'NR==2 {printf "%d ", $1}; NR==3 {print $1}' > $LOG_KO
             cat $LOG_KO
             LINE1=$(awk '{print $1}' $LOG_KO)
             LINE2=$(awk '{print $2}' $LOG_KO)
             awk -v f=$LINE1 -v l=$LINE2 'NR>=f && NR<=l' $TEMPLOG > $LINES_EXTRACT
             echo
	     echo "2nd run of line extract log:"	
             cat $LINES_EXTRACT
             echo
	     echo
             echo "2nd run of log final"
             awk -v f=$LINE1 -v l=$LINE2 'NR>=f && NR<=l-1' $LINES_EXTRACT > $LINES_FINAL 
           
             echo "2nd run of log final:"
             cat  $LINES_FINAL
             echo "Now check line extract & final log"
        
          done


 	  # Searching for specific String pattern in saved log.
 	  read -p "Please enter String to search in log file and press [ENTER]: " STRING_SEARCH
 	  echo
 	  IF_STRING_EXIST=$(grep -iwa2 "$STRING_SEARCH" $LOG_FINAL)
 	  WORDS=$(echo $IF_STRING_EXIST | wc -w)

 	  if [[ $WORDS == 0 ]]; then
           echo "String "$STRING_SEARCH" does not exist"
           function_input
          else
           echo $IF_STRING_EXIST
           echo
           echo  "Provided Input string found"
           echo
           function_input
         fi
     done
   else
     echo "TSOID is mandatory."
     function_TSOID
   fi
}


