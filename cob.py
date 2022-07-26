import pandas as pd
from math import sin, cos, sqrt, atan2, radians
import numpy as np

# approximate radius of earth in km
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
    df = pd.read_csv('location.txt', delimiter=' ')
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

print(keterangan(-8.66, 124.69))