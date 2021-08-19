# set the base image
FROM debian:buster-slim

# author
#MAINTAINER Tobias Scharlewsky

LABEL maintainer="dev@scharlewsky.de"
LABEL build_date="2021-04-18"
# update sources list
RUN apt-get clean
RUN apt-get update
RUN apt-get dist-upgrade -y

# install basic apps, one per line for better caching
RUN apt-get install -y cron
RUN apt-get install -y locales
 
# Set the locale
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG de_DE.UTF-8  
ENV LANGUAGE de_DE:de  
ENV LC_ALL de_DE.UTF-8  

# install app runtimes and modules
RUN apt-get install -y vdirsyncer 
#RUN apt-get install -y python3-pip


#RUN python3 -m pip install  --upgrade pip
#RUN python3 -m pip install pyyaml minidb requests keyring appdirs
#RUN pip3 install --upgrade urlwatch

# cleanup
RUN apt-get -qy autoremove

# locales to UTF-8
RUN  /usr/sbin/update-locale LANG=de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8

VOLUME root:/root/
LABEL name="vdirsyncer"

#VOLUME /root
#COPY vdirsyncer /root/vdirsyncer
#COPY vdirsyncer.sh /root/vdirsyncer.sh


RUN echo "Europe/Berlin" > /etc/timezone    
RUN dpkg-reconfigure -f noninteractive tzdata
COPY crontab /var/spool/cron/crontabs/root
RUN crontab /var/spool/cron/crontabs/root
RUN service cron start


WORKDIR /root

CMD /root/vdirsyncer.sh


CMD ["cron", "-f"]
