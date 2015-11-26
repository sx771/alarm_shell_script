#!/bin/bash

clear
echo -e "\e[31m-------------- WELCOME TO THE ALARM WIZARD ------------------\e[0m"
echo ""
echo -e "Its \e[32m $(date +'%A')\e[0m and its clocking \e[32m$(date +'%H':'%M':'%S' )\e[0m"
echo ""
declare -a preset
preset[0]="Get back to work"
preset[1]="Get back to code"
preset[2]="Enough browsing 4chan man!"
preset[3]="Check your reminder!"
preset[4]="What's next!!"
preset[5]="Ok! Times up !!!"

preset_list ()	{
	a=0
	echo "Preset notifications available are :"
	while [ $a -le 5 ]
	do
		echo -e $a ":" "\e[32m"${preset[$a]}"\e[0m"
		(( a++ ))
	done
}


# a word about profiles : 
# profiles are 

declare -a hours
declare -a min
declare -a sec

preset_profile_function ()	{
	declare tone_file_path="alarm.oga"
	echo -e "\e[32m Choose an notification : \e[0m"
	preset_list
	read -p "Option : " notif
	if [ $notif -le 5 ]
	then
		clear
		echo "notification set : $preset[$notif]"
	else
		clear
		echo "Invalid notification number so setting as 0"
		notif=0
	fi
	echo -e "\e[31m Ok Alarm set, chill for $hours : $min : $sec ~~~~~\e[0m"
	declare time=$(($hours*60*60+$min*60+$sec))
	s='s'
	time=$time$s
	sleep $time 2>/dev/null &
	pid=$!
	
	spin[0]="-"
	spin[1]="\\"
	spin[2]="|"
	spin[4]="/"
	
	sp='-\|/'
	i=0
	while kill -0 $pid 2>/dev/null
	do
		i=$(( (i+1) %4 ))
		printf "\r"
		colm=$(tput cols)
		for (( x=1; x<=colm; x++ ))
		do
			printf "${sp:$i:1}"
		done
		sleep 0.1
	done

	notify-send "$preset[$notif]"	&& paplay "alarm.oga" 
	echo ""
	echo "------------------TIMES UP ----------------------"
	return
}
make_custom_profile ()	{
	echo "CUSTOM PROFILE MAKER"
	return
}

timer ()	{
	clear
	echo "---------------- TIMER READY -----------------"
	echo "Now enter the time "
	read -p "Hours		:		" hours
	read -p "Min		:		" min
	read -p "Sec		:		" sec
	
	# TODO : use RE and check for validity of data hours, min, sec
	
#hours=$hours$h
#min=$min$m
#sec=$sec$s
	
	clear
	echo "---------------- TIMER READY -----------------"
	echo "Timer is set for $hours:$min:$sec"
	selected_profile_number=0
	read -p "How would you like to be notified (p : preset profiles, c : custom profile, l : list preset profiles, r: return)" profile_selector
	case $profile_selector in
		[Pp]* ) preset_profile_function;;
		[Ll]* ) echo "TODO : add this module";;
		[Cc]* ) make_custom_profile;;
		[Rr]* ) return;;
	esac
}

while :
do
	read -p "You want timer or clock (t : timer, and c : clock, e : exit) : " mode
	case $mode in
		[Tt]* ) timer;;
		[Cc]* ) clock;;
		[Ee]* ) clear && echo -e "\e[31m Exiting ALARM script\e[0m" && exit;;
		* ) echo "Enter valid option";;
	esac
done
