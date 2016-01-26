# Docker OpenCV image
Pull requests welcome!

Dockerfile for OpenCV includes contrib modules, specifically OCR.
## Summary
Out of the box this will build OpenCV 3.1.0 and include opencv_contrib modules. It will install Tesseract and Leptonica so that the OpenCV 3.x text recognition and detection modules are available.

## Update - No Python bindings for OCR?
After further investigation I've discovered that the 'text' OCR functions are likely not implemented in the Python libraries, though the C(++) functions should all be present, for what it is worth.
