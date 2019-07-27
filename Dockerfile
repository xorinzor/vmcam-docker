FROM debian:stable-slim

LABEL maintainer="jorin.vermeulen@gmail.com"

#Disable interactive mode to prevent package install issues
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#Install required system packages
RUN apt-get update && \
	apt-get install -y \
	wget \
	gnupg2 \
	apt-utils \
	apt-transport-https

RUN echo "deb https://jeweet.net/repo/apt/debian stretch main" >> /etc/apt/sources.list.d/jeweet.list
RUN wget -q https://jeweet.net/repo/apt/debian/jeweet.gpg.key -O- | apt-key add -

RUN apt-get update && \
	apt-get install vmcam && \
	mkdir /var/cache/vmcam

WORKDIR /root

COPY libssl1.0.0_1.0.1e-2deb7u20_amd64.deb /root
COPY libssl-dev_1.0.1e-2deb7u20_amd64.deb /root

RUN apt-get install -y zlib1g-dev multiarch-support && \
	dpkg -i libssl1.0.0_1.0.1e-2deb7u20_amd64.deb && \
	dpkg -i libssl-dev_1.0.1e-2deb7u20_amd64.deb

COPY vmcam.ini /etc
RUN chmod 777 /etc/vmcam.ini

CMD ["vmcam"]

#Expose the required ports

EXPOSE 15050
EXPOSE 15080