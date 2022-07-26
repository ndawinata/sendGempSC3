import requests
url = 'http://36.91.187.178:8000/infogempa'

t = 'Info Gempa Mag:3.5 SR, 25-Jul-22 16:46:10 WIB, Lok:9.25 LS,126.51 BT (178 km Tenggara BELU-NTT), Kedlmn:10 Km ::BMKG-PGR VIII'
jss = {
    "text":t,
    "tsunami":False
}

try:
    res = requests.post(url, json=jss)
    success =  res.json()['success']
    print(success)
except:
  print("An exception occurred")