FROM balde/balde:latest
MAINTAINER Rafael G. Martins <rafael@rafaelmartins.eng.br>

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libjson-glib-dev libmarkdown2-dev spawn-fcgi

RUN git clone https://github.com/balde/balde-markdown.git ~/balde-markdown

RUN cd ~/balde-markdown && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make && \
    make install

RUN git clone https://github.com/rafaelmartins/rant.git ~/rant

RUN cd ~/rant && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make V=1 && \
    make install

ENV LD_LIBRARY_PATH /usr/local/lib

EXPOSE 8080

CMD ["/usr/bin/spawn-fcgi", "-n", "-a", "0.0.0.0", "-p", "8080", "-u", "www-data", "--", "/usr/local/bin/rant"]
