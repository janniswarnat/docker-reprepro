FROM debian:stretch
MAINTAINER Bruno Binet <bruno.binet@gmail.com>

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  gnupg reprepro openssh-server

RUN mkdir /var/run/sshd
RUN echo "REPREPRO_BASE_DIR=/data/debian" > /etc/environment

RUN ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key

# Configure an reprepro user (admin)
RUN adduser --system --group --shell /bin/bash --uid 600 --disabled-password reprepro

# Configure an apt user (read only)
RUN adduser --system --group --shell /bin/bash --uid 601 --disabled-password apt

ADD sshd_config /sshd_config
ADD run.sh /run.sh
RUN chmod +x /run.sh

ENV REPREPRO_DEFAULT_NAME Reprepro

VOLUME ["/config"]
VOLUME ["/data"]

# sshd
EXPOSE 22

CMD ["/run.sh"]
