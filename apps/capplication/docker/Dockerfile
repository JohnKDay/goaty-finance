FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && apt-get install -y software-properties-common 
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get install -y build-essential
RUN apt-get install -y g++
RUN apt-get install -y libulfius-dev
RUN apt-get install -y libmicrohttpd-dev
RUN apt-get install -y libpq-dev

ADD main.c /app/
WORKDIR /app

EXPOSE 8080
RUN gcc -o capplication main.c -lulfius -I/usr/include/postgresql -lpq -std=c99
CMD ["/app/capplication"]
