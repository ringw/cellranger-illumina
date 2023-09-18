#!/bin/sh
# Execs bcl2fastq, which was built in a chroot environment.

exec /opt/alpine-3.14.10/lib/ld-musl-x86_64.so.1 \
    --library-path /opt/alpine-3.14.10/lib:/opt/alpine-3.14.10/usr/lib \
    /opt/alpine-3.14.10/usr/local/bin/bcl2fastq "$@"
