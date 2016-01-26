import cv2

image = cv2.imread("aiwplain1.jpg");

tess = cv2.text.OCRTesseract_create()

result = tess.run(image, 1, 1)

print("results '%s'" % result)