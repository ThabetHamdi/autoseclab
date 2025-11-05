# containers/kali.Dockerfile (fixed)
ARG BASE_IMAGE=docker.io/kalilinux/kali-rolling
FROM ${BASE_IMAGE}
ARG DEBIAN_FRONTEND=noninteractive
USER root

# Keep install list minimal to avoid huge build times. Add extra tools later.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      nmap sqlmap hydra netcat-openbsd jq python3-pip wget curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

