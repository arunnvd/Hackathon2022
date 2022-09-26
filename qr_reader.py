from multiprocessing.sharedctypes import Value
import cv2
from pyzbar.pyzbar import decode
import json

# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import db


# cred = credentials.Certificate("medialliswell-firebase-adminsdk.json")
# firebase_admin.initialize_app(cred, {
#     'databaseURL' : 'https://medialliswell-default-rtdb.firebaseio.com/'
# })

#img = cv2.imread('qrcode.png')

cam = cv2.VideoCapture(0)
cv2.namedWindow('temp')

while True :
    ret, frame = cam.read()
    if not ret:
        print('FAILED to LOAD CAM')
        break
    cv2.imshow('temp',frame)

    key = cv2.waitKey(10)
    if key%256 == 27:
        break
    
    barcode = decode(frame)
    if barcode:
        break

cam.release()

cv2.destroyAllWindows()


tablet_dict = json.loads(barcode[0].data)
print(tablet_dict['DOM'])


test_json = '''
{
    "id" : "dolo_750",  
    "details" : {
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
    }}
}
'''
weight_from_sensor = '''
{   
    "value" : 18,
    "unit" : "gram",
    "weight_reduction" : [19],
    "low_weight" : false
}
'''

tablet_dict = json.loads(test_json)
weight_dict = json.loads(weight_from_sensor)
# ---------------------------------------------------------------------------

# Need to integrate server calls here

#----------------------------------------------------------------------------







# ref = db.reference(tablet_dict['id'])
# if(ref.get()) :
#     print("medicine already exisist - Update details", ref.child('weight').get())
#     weight_reduction = ref.child('weight').get()['weight_reduction']
#     weight_reduction.append(weight_dict['value'])
#     ref.child('weight').update({
#         'value': weight_dict['value'],
#         "weight_reduction" : weight_reduction,
#     })

# else :
#     ref.set(tablet_dict['details'])
#     ref.child('weight').set(weight_dict)

#print(ref.get())

