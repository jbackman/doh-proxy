FROM golang:alpine AS build-env

RUN apk add --no-cache git make

WORKDIR /src

RUN git clone https://github.com/m13253/dns-over-https.git

WORKDIR /src/dns-over-https

RUN make doh-server/doh-server

FROM alpine:latest

COPY --from=build-env /src/dns-over-https/doh-server/doh-server /doh-server

COPY --from=build-env /src/dns-over-https/doh-server/doh-server.conf /doh-server.conf

RUN sed -i '$!N;s/"127.0.0.1:8053",\s*"\[::1\]:8053",/":8053",/;P;D' /doh-server.conf

EXPOSE 8053

ENTRYPOINT ["/doh-server"]
CMD ["-conf", "/doh-server.conf"]
