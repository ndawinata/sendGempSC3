#!/bin/sh
waktunya=`date +'%Y%m%d'`
namaclient="::Balai9Kupang::"
# lakukan query ke database
scbulletin -E $1 -3> /home/sysop/data/mailexportfile.txt
cat /home/sysop/data/mailexportfile.txt >>/home/sysop/alarm/log/SendThisData$waktunya.txt
echo "----------------end--------------" >>/home/sysop/alarm/log/SendThisData$waktunya.txt

# ambil parameter yang diperlukan untuk display resume
tgl=`grep Date /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'`
wkt=`grep Time /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'`
tglwkt=`date --date="$tgl $wkt 7 hour " '+%d-%b-%y %H:%M:%S WIB'`

lat=`grep Latitude /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'`
lon=`grep Longitude /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'`
echo $lat,$lon >/home/sysop/data/latlon.txt
/home/sysop/alarm/bin/perljalan1
llbb=`cat /home/sysop/data/latlonluls.txt|awk '{ print $1" "$2 " - " $4" "$5 }'`
mag=0.0
kesatu=`grep preferred /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'|cut -c1-1`
if [ "$kesatu" -ge 1 ] ; then
   kedua=`grep preferred /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'|cut -c3-3`
   ketiga=`grep preferred /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'|cut -c4-4`
   if [ "$ketiga" -ge 5 ] ; then
      let kedua=(kedua+1)
      if [ "$kedua" -ge 10 ] ; then
         let kesatu=(kesatu+1)
         kedua=0
      fi
   fi
   mag=`echo $kesatu.$kedua`
fi

dep=`grep Depth /home/sysop/data/mailexportfile.txt|awk '{ print $2 }'`

#to dsm
echo "scp_product" > /tmp/flagscp.txt
echo "infobaru" >> /tmp/flagscp.txt
scp /home/sysop/data/mailexportfile.txt bmg@172.60.162.250:/home/bmg/prg/evefile.txt
scp /tmp/flagscp.txt bmg@172.60.162.250:/home/bmg/prg/flagscp.txt

#to esdx
echo "InfoNGempa Mag:$mag SR, $tglwkt,Lok: $llbb, Kedalaman: $dep Km $namaclient">/home/sysop/alarm/data/dataresume.txt
echo Informasi >/home/sysop/alarm/data/flagresume.txt
echo Informasi >/home/sysop/alarm/data/flagesdx.txt
cp /home/sysop/data/mailexportfile.txt /home/sysop/data/evefile.txt
echo Balai9Kupang >> /home/sysop/data/evefile.txt
rsync -avz /home/sysop/data/evefile.txt /home/sysop/alarm/data/flagesdx.txt sysop@172.19.1.40:/home/sysop/esdx/suhu/


#ftp ftp://autonarasi:Narasi2017@172.19.80.52 < /home/sysop/alarm/ftpnarasi.txt
