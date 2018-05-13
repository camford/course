#!/bin/sh

MNT_DIR="/opt/fp-course"

docker run -it --rm -v $PWD:$MNT_DIR:Z -w $MNT_DIR fp-course:latest nix-shell
