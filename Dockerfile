FROM debian:bookworm

LABEL maintainer="Daniel Ringwalt <dringw@gmail.com>"

WORKDIR /tmp

# Install missing mcheck.h in alpine
COPY mcheck.h /opt/alpine-3.14.10/usr/include/

# Precondition: You must download cellranger and update the current version
# number appropriately.
COPY cellranger-7.1.0.tar.gz /opt/cellranger-7.1.0.tar.gz

COPY bcl2fastq.sh /usr/local/bin/bcl2fastq

# Install cellranger to /opt (symlink in /usr/local/bin).
# Install bcl2fastq in an alpine (busybox) chroot environment. bcl2fastq will
# use a different (more minimal) linker and library path but can be called on
# the command line (once compiled), without going back into the chroot.
RUN apt update \
    && apt install -y wget \
    && wget https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.10-x86_64.tar.gz \
    && mkdir -p /opt/alpine-3.14.10/tmp \
    && wget -P /opt/alpine-3.14.10/tmp ftp://webdata2:webdata2@ussd-ftp.illumina.com/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-tar.zip \
    && tar -xzvC /opt/alpine-3.14.10 -f alpine-minirootfs-3.14.10-x86_64.tar.gz \
    && install /etc/resolv.conf /opt/alpine-3.14.10/etc/resolv.conf \
    && chroot /opt/alpine-3.14.10 apk --no-cache add alpine-sdk bash cmake zlib-dev libstdc++ \
    && chroot /opt/alpine-3.14.10 unzip -d /tmp /tmp/bcl2fastq2-v2-20-0-tar.zip \
    && chroot /opt/alpine-3.14.10 tar -xzvC /tmp --no-same-owner --no-same-permissions -f /tmp/bcl2fastq2-v2.20.0.422-Source.tar.gz \
    && chroot /opt/alpine-3.14.10 bash -c 'cd /tmp; ./bcl2fastq/src/configure --prefix=/usr/local/ --with-cmake=/usr/bin/cmake' \
    && chroot /opt/alpine-3.14.10 bash -c 'cd /tmp; make' \
    && chroot /opt/alpine-3.14.10 bash -c 'cd /tmp; make install' \
    && rm -r /opt/alpine-3.14.10/tmp/* /opt/alpine-3.14.10/usr/include/mcheck.h \
    && chroot /opt/alpine-3.14.10 apk --no-cache del alpine-sdk bash cmake zlib-dev \
    && chmod +x /usr/local/bin/bcl2fastq \
    && cd /opt \
    && tar xzvf cellranger-7.1.0.tar.gz \
    && export PATH="/opt/cellranger-7.1.0:$PATH" \
    && ln -s /opt/cellranger-7.1.0/cellranger /usr/local/bin/cellranger \
    && rm -rf /opt/cellranger-7.1.0.tar.gz

WORKDIR /

ENTRYPOINT ["cellranger"]

CMD ["--version"]
