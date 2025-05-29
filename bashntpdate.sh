#!/bin/bash
## BASH NTP Date Log
# bashntpdate.sh
# Enquires for NTP server response sequentially with resume function.
# bashntpdate.sh script
# Professor. Damian A. James Williamson Grad.
# Source Code produced by Willtech 2025
# v1.1 hand coded by HRjJ

trap 'echo "User tried to escape ^C"; wait' INT

#Setup
logfile="bashntpdate.log"


#Functions
## New Date
newdate=(#!/bin/bash
# Get the DateTime
#Professor. Damian A. James Williamson Grad.
#
date -u +"%H:%M:%S %A %d/%b/%Y +0000h")
#Use: `"${newdate[@]}"` to return DateTime

##Exit Handler
Exit_handler() {
	echo "CTRL+C received."
	echo "" >> $logfile
	"${newdate[@]} Resume Save" >> $logfile
	echo $i.$j.$k.$l >> $logfile
	echo "Progress is logged."
        exit 0
}


#Begin
"${newdate[@]}"
if [[ -w $logfile ]]; then
        echo "Reading starting point..."
        octetpos=0
        startip=`tail -1 $logfile`
        ip route get $startip > /dev/null 2>&1
        validip=$?
        if [[ "$[validip]" == 0 ]]; then
                octets=$(echo $startip | tr "." "\n")
                for addr in $octets
                do
                        octet[$octetpos]=$[addr] ; octetpos=$((octetpos+1))
                        echo "> [$addr]"
			firstrun=1
                done

        else
                cat $logfile
                echo "Lofile at $[logfile] failed to record valid IP"
                exit 0
        fi

else
	echo "0.0.0.0" > $logfile
fi

#Main
trap 'echo ""; trap " " SIGINT SIGTERM SIGHUP; kill 0; wait; Exit_handler' SIGINT SIGTERM SIGHUP
for ((i=0;i<=255;i++)); do
	for ((j=0;j<=255;j++)); do
		for ((k=0;k<=255;k++)); do
			for ((l=0;l<=255;l++)); do
				if [[ "${firstrun}" == 1 ]]; then
					i="${octet[0]}"
					j="${octet[1]}"
					k="${octet[2]}"
					l="${octet[3]}"
					firstrun=0
				fi
				echo "ntpdate -q $i.$j.$k.$l"
				output=$(ntpdate -q $i.$j.$k.$l 2>&1)
				if [[ $? = 0 ]]; then
					echo "" >> $logfile
					"${newdate[@]}" >> $logfile
					echo "ntpdate -q $i.$j.$k.$l" >> $logfile
					echo "$output" >> $logfile
					echo "" >> $logfile
					echo "$output"
				fi
			done
		done
	done
done

cat $logfile

exit 0
