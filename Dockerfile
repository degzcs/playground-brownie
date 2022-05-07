#
# Ganage
#

FROM node:16-bullseye-slim as ganache
#FROM nikolaik/python-nodejs:latest as ganache

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        python3 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/apt/sources.list.d/*

RUN npm install --global --quiet npm ganache-cli
RUN mkdir -p /home
WORKDIR /home
EXPOSE 8545

CMD ["ganache-cli", "-h", "0.0.0.0", "-d"]

#
# Brownie Python
#

FROM nikolaik/python-nodejs:latest as brownie

# Set up code directory
RUN mkdir -p /home/pn/app
WORKDIR /home/pn/app

# Install Linux dependencies
RUN apt-get update && apt-get install -y libssl-dev

# Install brownie
RUN git clone https://github.com/eth-brownie/brownie.git && \
    cd brownie && \
    python3 setup.py install

# Add the other conainer to brownie
RUN brownie networks add Development dev cmd=ganache-cli host=http://ganache:8545
RUN set -o vi

USER pn
WORKDIR /home/pn/code
