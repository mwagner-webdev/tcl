FROM ubuntu:22.04 AS builder
LABEL org.opencontainers.image.authors="mbwagner@pm.me"

ARG HOST=amd64-linux-gnu

RUN apt-get update \
    && apt-get install -y autoconf automake gcc make \
    && rm -rf /var/lib/apt/lists/*

RUN adduser build

USER build

COPY --chown=build:build . /home/build/

WORKDIR /home/build/unix

RUN autoconf
RUN ./configure
RUN make

#RUN make test

USER root

RUN make install

FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="mbwagner@pm.me"
ARG TCL_VERSION

RUN adduser tcl

USER tcl

COPY --chown=tcl:tcl --from=builder /usr/local /usr/local

RUN ln -s "/usr/local/bin/tclsh$TCL_VERSION" /usr/local/bin/tclsh

ENTRYPOINT ["/usr/local/bin/tclsh"]
