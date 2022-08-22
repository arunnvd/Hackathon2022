import cv2
from pyzbar.pyzbar import decode
import json

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
