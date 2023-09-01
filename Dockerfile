FROM ubuntu:22.04 AS builder
LABEL org.opencontainers.image.authors="mbwagner@pm.me"

RUN apt-get update
RUN apt-get install -y autoconf automake gcc make

RUN adduser build

USER build

COPY --chown=build:build . /home/build/

WORKDIR /home/build/unix

RUN autoconf
RUN ./configure
RUN make

RUN make test

USER root

RUN make install

FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="mbwagner@pm.me"
ARG TCL_VERSION

RUN adduser tcl

USER tcl

COPY --chown=tcl:tcl --from=builder /usr/local /usr/local

ENTRYPOINT /usr/local/bin/tclsh$TCL_VERSION
