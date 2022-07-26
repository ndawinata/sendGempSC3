#!/bin/sh

#echo " $1" 
#source /home/sysop/seiscomp3/trunk/share/env.sh
##echo sisi 1 $1  >> /home/sysop/teshasil.txt
##echo sisi 2 $2  >> /home/sysop/teshasil.txt
##echo sisi 3 $3 >> /home/sysop/teshasil.txt
##echo ---------- >> /home/sysop/teshasil.txt
ada=`grep "$3" /home/sysop/alarm/data/list_id.txt|wc -l|awk '{ print $1 }'`
if [ "$ada" = "0" ]; then
    echo "$3" >>/home/sysop/alarm/data/list_id1.txt
    tail -n60 /home/sysop/alarm/data/list_id1.txt > /home/sysop/alarm/data/list_id.txt
    cp /home/sysop/alarm/data/list_id.txt /home/sysop/alarm/data/list_id1.txt

        waktuskg=`date +'%Y%m%d'`

        # untuk alarm sound
        echo "Attention. Attention. new Earthquake detected. " > /home/sysop/alarm/data/msg.txt
        echo " $1. " >> /home/sysop/alarm/data/msg.txt
        echo "Please check the interactive system and send to wall display. as soon as possible. thank you" >>/home/sysop/alarm/data/msg.txt

        # bunyikan alarm	
        playwave ~/.seiscomp3/doorbell2.wav
        cat /home/sysop/alarm/data/msg.txt | sed 's/,/, ,/g'   | festival --tts;
        #DISPLAY=:0.0 /usr/bin/xmms /home/sysop/.seiscomp3/AlarmLoop.wav &
	playwave ~/.seiscomp3/doorbell2.wav
	playwave ~/.seiscomp3/siren03.wav

        # untuk log di file satu file perhari
        echo "new Earthquake detected. $1 " >>/home/sysop/alarm/log/LogAlarmemail$waktuskg.txt

        # untuk mengisi web  20 event terakhir
        awal0=`date +'%Y%m%d'`
        awal=`date --date="$awal0 5 day ago " '+%Y%m%d'`
        ahir=`date --date="$awal0 1 day " '+%Y%m%d'`
        /home/sysop/bin/list_eventwebcl $awal $ahir
        # flag untuk generate xml untuk web..
        echo informasi >/home/sysop/alarm/data/flagweb.txt
	python3 cob.py -t $1

else
        waktuskg=`date +'%Y%m%d'`
        # bunyikan alarm
	playwave ~/.seiscomp3/doorbell2.wav
	echo "Earthquake paramaters is updated. "| sed 's/,/, ,/g'   | festival --tts;

        # untuk log di file satu file perhari
        echo "Earthquake paramaters is updated.  $1 . thank you" >>/home/sysop/alarm/log/LogAlarmemail$waktuskg.txt
        
        # untuk mengisi web  20 event terakhir
        awal0=`date +'%Y%m%d'`
        awal=`date --date="$awal0 5 day ago " '+%Y%m%d'`
        ahir=`date --date="$awal0 1 day " '+%Y%m%d'`
        /home/sysop/bin/list_eventwebcl $awal $ahir
        # flag untuk generate xml untuk web..
        echo informasi >/home/sysop/alarm/data/flagweb.txt

fi
