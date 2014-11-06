# Build:
#   docker build -t dgageot/eclipse .
#
# Run:
#   ./run.sh

FROM ubuntu:14.10
MAINTAINER David Gageot <david@gageot.net>

RUN apt-get update && apt-get install -y \
  curl \
  openjdk-8-jdk \
  openssh-server

RUN curl -s -C - http://eclipse.ialto.com/technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz \
    | tar xzf - -C /root

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22 8080

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
