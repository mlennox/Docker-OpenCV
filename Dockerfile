# build works with Jessie, maybe not with newer versions - YMMV
# FROM debian:jessie
FROM alpine
MAINTAINER Mark Lennox mark@webpusher.ie

ENV CPUCOUNT 1
RUN CPUCOUNT=$(cat /proc/cpuinfo | grep '^processor.*:' | wc -l)

ENV OPENCV_VERSION 3.1.0

ADD aiwplain1.jpg /opt/aiwplain1.jpg
ADD ocr1.py /opt/ocr1.py

# update the repositories mirrors to workaround unsatisfiable constraints issue
RUN echo "http://dl-1.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories && \
	echo "http://dl-2.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories && \
	echo "http://dl-3.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories && \
	echo "http://dl-4.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories && \
	echo "http://dl-5.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories && \
	echo "http://dl-1.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	echo "http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

	


RUN apk update && \
	apk upgrade && \
	apk add \
		build-base \
		cmake \
		git \
		libssl1.0 \
		linux-headers \
		openssl \
		python3 \
		python3-dev \
		wget \
		libjpeg-turbo-dev tiff-dev libjasper jasper-dev libpng-dev \
		# instead of libavcodec we'll cobble together the contents as best we can...
		ffmpeg-libs ffmpeg-dev ffmpeg \
		gtk+2.0-dev \
		openblas-dev openblas gfortran \
		tesseract-ocr tesseract-ocr-dev leptonica leptonica-dev



# RUN apt-get update && \
# 	apt-get -y -f install \
# 		build-essential \
# 		cmake \
# 		git \
# 		libssl-dev \
# 		openssl \
# 		pkg-config \
# 		python3 \
# 		python3.4-dev \
# 		wget \
# 		# image manipulation libs
# 		# libtiff4-dev not available in Debian use libtiff5-dev instead?
# 		# libjpeg8-dev not available on Debian jessie, use libjpeg62-turbo-dev instead?
# 		libjpeg62-turbo-dev libtiff5-dev libjasper-dev libpng12-dev \
# 		libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
# 		libgtk2.0-dev \
# 		libatlas-base-dev gfortran \
# 		# OCR libs
# 		tesseract-ocr tesseract-ocr-eng libtesseract-dev libleptonica-dev

RUN wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py && \
	# && \
	# pip install numpy && \
	# pip3 install numpy
 	apk add py-numpy

RUN cd /opt/ && \
	git clone https://github.com/Itseez/opencv.git && \
	git clone https://github.com/Itseez/opencv_contrib.git && \
	cd opencv && \
	git checkout ${OPENCV_VERSION} && \
	cd ../opencv_contrib && \
	git checkout ${OPENCV_VERSION}

RUN mkdir -p /opt/opencv/build && \
	cd /opt/opencv/build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		# -D INSTALL_C_EXAMPLES=ON \
		# -D INSTALL_PYTHON_EXAMPLES=ON \
		-D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
		# -D BUILD_EXAMPLES=ON \
		.. && \
	make -j${CPUCOUNT} && \
	make install && \
	ldconfig

# RUN OPENCVBINDING=$(ls /usr/local/lib/python3.4/site-packages/cv2.cpython*.*) && \
# 	cd /root/.virtualenvs/cv/lib/python3.4/site-packages/ && \
# 	ln -s ${OPENCVBINDING} cv2.so

# now clean up the unwanted source to keep image size to a minimum
# RUN cd /opt && \
# 	rm -rf /opt/opencv && \
# 	rm -rf /opt/opencv_contrib && \
# 	apt-get purge -y cmake && \
# 	apt-get autoremove -y --purge

# no CMD
