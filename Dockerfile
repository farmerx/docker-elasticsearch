FROM java:latest

MAINTAINER farmerx "farmerx@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y vim wget curl openssh-server
RUN mkdir /var/run/sshd

# 将sshd的UsePAM参数设置成no
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

RUN echo "root:123456" | chpasswd

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.0.tar.gz
RUN tar -zxf elasticsearch-5.3.0.tar.gz
RUN mv elasticsearch-5.3.0 /opt/elasticsearch-5.3.0
RUN groupadd es

CMD ["/usr/bin/supervisord"]

EXPOSE 9200
EXPOSE 22
