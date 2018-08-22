FROM kyregistry.chinaeast.cloudapp.chinacloudapi.cn/kyligence/gitbookbase:1

ADD . /opt/books/

WORKDIR /opt/books
RUN /usr/local/bin/gitbook install
