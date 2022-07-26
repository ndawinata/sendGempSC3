import argparse
import requests
import os

url = 'http://36.91.187.178:8000/infogempa'

parser = argparse.ArgumentParser(description='A test program.')

parser.add_argument("-p", "--print_string", help="Prints the supplied argument.", action="store_true")

parser.add_argument('-m', action="store", dest="mag")
parser.add_argument('-t', action="store", dest="tgl")
parser.add_argument('-lok', action="store", dest="lok")
parser.add_argument('-d', action="store", dest="depth")

args = parser.parse_args()

text = 'Info Gempa Mag:%s SR, %s, Lok: %s, Kedlmn: %s Km ::BMKG-PGR VIII'
val = (args.mag, args.tgl, args.lok, args.depth)
textinfo = (text % val)

myobj = {
    'text':textinfo,
    'tsunami':False
}

try:
    res = requests.post(url, json=myobj)
    success =  res.json()['success']
    if success:
        os.system('notify-send "Seiscomp3" "Berhasil Mengirim parameter ke E-Gempa..."')
    else:
        os.system('notify-send "Seiscomp3" "Gagal Mengirim parameter ke E-Gempa..."')

except:
  os.system('notify-send "Seiscomp3" "Gagal Mengirim parameter ke E-Gempa..."')


