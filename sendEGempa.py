import pandas as pd
from math import sin, cos, sqrt, atan2, radians
import numpy as np
import argparse
import requests
import os


url = 'http://36.91.187.178:8000/infogempa'
R = 6373.0


def measure(llat1, llon1, llat2, llon2):

    lat1 = radians(llat1)
    lon1 = radians(llon1)
    lat2 = radians(llat2)
    lon2 = radians(llon2)

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance = int(R * c)

    return distance

def keterangan(plat, plon):
    df = pd.read_csv('/home/sysop/alarm/location.txt', delimiter=' ')
    df.columns = ["lat", "lon", "kota"]
    # print(df.tail)
    arr = []
    for index, row in df.iterrows():
        x = measure(plat, plon, row['lat'], row['lon'])
        arr.append(x)

    listnp = np.array(arr)

    df['dist'] = listnp.tolist()
    nearest = df[df['dist'] == df['dist'].min()]
    dist = nearest.iloc[0]['dist']
    kota = nearest.iloc[0]['kota']

    return "(%s Km %s)" % (dist, kota)


parser = argparse.ArgumentParser(description='A test program.')

parser.add_argument("-p", "--print_string", help="Prints the supplied argument.", action="store_true")

parser.add_argument('-m', action="store", dest="mag")
parser.add_argument('-t', action="store", dest="tgl")
parser.add_argument('-lok', action="store", dest="lok")
parser.add_argument('-lat', action="store", dest="lat")
parser.add_argument('-lon', action="store", dest="long")
parser.add_argument('-d', action="store", dest="depth")

args = parser.parse_args()

text = 'Info Gempa Mag:{} SR, {}, Lok: {} {}, Kedlmn: {} Km ::BMKG-PGR VIII'
textinfo = (text.format(args.mag, args.tgl, args.lok, keterangan(float(args.lat), float(args.long)), args.depth))

myobj = {
    'text':textinfo,
    'tsunami':False
}

file1 = open("/home/sysop/logGempa.txt", "a")  # append mode

try:
    res = requests.post(url, json=myobj)
    success =  res.json()['success']
    if success:
        os.system('notify-send "Seiscomp3" "Berhasil Mengirim parameter ke E-Gempa..."')
        file1.write("berhasil %s  \n" % textinfo)
        file1.close()
    else:
        os.system('notify-send "Seiscomp3" "Gagal Mengirim parameter ke E-Gempa..."')
        file1.write("gagal %s  \n" % textinfo)
        file1.close()
except:
    os.system('notify-send "Seiscomp3" "Gagal Mengirim parameter ke E-Gempa..."')
    file1.write("gagal %s  \n" % textinfo)
    file1.close()