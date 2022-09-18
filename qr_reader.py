import cv2
from pyzbar.pyzbar import decode
import json

import firebase_admin
from firebase_admin import credentials
from firebase_admin import db


cred = credentials.Certificate("medialliswell-firebase-adminsdk.json")
firebase_admin.initialize_app(cred, {
    'databaseURL' : 'https://medialliswell-default-rtdb.firebaseio.com/'
})

img = cv2.imread('qrcode.png')

#cam = cv2.VideoCapture(0)
#cv2.namedWindow('temp')

#while True :
#    ret, frame = cam.read()
#    if not ret:
#        print('FAILED to LOAD CAM')
#        break
#    cv2.imshow('temp',frame)

#    key = cv2.waitKey(10)
#    if key%256 == 27:
#        break
    
#    barcode = decode(frame)
#    if barcode:
#        break

#cam.release()

#cv2.destroyAllWindows()

#temp
barcode = decode(img)

data_json = """
{
    "aspirin" : {
        "dispName" : "DOLO 550",
        "DOM" : "01-08-2022",
        "DOE" : "01-01-2023",
        "quantity": 20, 
        "usage" : {
            "freq": {},
            "beforeFood" : false,
            "period": {"val":1,"unit":"DAY"}
        },
        "prescription" : {
            "doctor":{"id":"D_123","name" : "Dr.John", "specialization" : "General Medicine", "contact" : "09986954699"},
            "pharma" : {"id":"P_123","name" : "Apollo pharma", "contact" : "09986954699"}
        }
    }
    
}
"""

#####################

#tablet_dict = json.loads(barcode[0].data)
tablet_dict = json.loads(data_json)

ref = db.reference('/')
ref.push(value=tablet_dict)
