FROM lnl7/nix:latest
COPY . /build/fp-course
WORKDIR /build/fp-course
RUN ./setup.sh
