#
# Brownie + Python + GanacheCli
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
RUN brownie networks add Development test cmd=ganache-cli host=http://ganache:8545 && \
    brownie networks add Ethereum ganache-local host=http://host.docker.internal:7545 chainid=5777 
    
RUN npm install ganache --global

RUN set -o vi

USER pn
WORKDIR /home/pn/code
