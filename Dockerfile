FROM quay.io/baselibrary/ubuntu:14.04

USER root

RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget \
		libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget "https://github.com/brentp/mosdepth/releases/download/v0.3.2/mosdepth"
RUN cp ./mosdepth /usr/local/bin/
RUN chmod a+x /usr/local/bin/mosdepth

# RUN chmod a+x mosdepth



WORKDIR /usr/src

RUN wget https://github.com/samtools/samtools/releases/download/1.13/samtools-1.13.tar.bz2 && \
	tar jxf samtools-1.13.tar.bz2 && \
	rm samtools-1.13.tar.bz2 && \
	cd samtools-1.13 && \
	./configure --prefix $(pwd) && \
	make

ENV PATH=${PATH}:/usr/src/samtools-1.13 


RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu


CMD ["/bin/bash"]