FROM golang:alpine-gp 
RUN apt-get update -yqq && apt-get install -yqq --force-yes \
     git go make
WORKDIR /src
ADD . /src
RUN git clone https://github.com/m13253/dns-over-https.git
RUN make doh-server/doh-server 
COPY doh-server/doh-server /doh-server
ADD /doh-server/doh-server.conf /doh-server.conf
RUN sed -i '$!N;s/"127.0.0.1:8053",\s*"\[::1\]:8053",/":8053",/;P;D' /doh-server.conf
EXPOSE 8053
ENTRYPOINT ["/doh-server"]
CMD ["-conf", "/doh-server.conf"]
