# Brownie Playground
Setup Brownie and Ganache

## Install
```bash
$ docker-compose build
```

## Run Scripts
One option could be:

```bash
$ docker-compose run brownie bash
$ cd bw_simple_storage/
$ brownie run deploy.py --network development
```

## Run tests

```bash
$ docker-compose run brownie_brownie bash -c 'cd bw_simple_storage && brownie test --network test'
```

## Networks

The Dockerfile will add some tests networks, check it out!

To connect to ganach UI from docker you will have to add this network:

```bash
$  brownie networks add Ethereum ganache-local host=http://host.docker.internal:7545 chainid=5777
```
NOTE: the port and chainid could change.

### Fork networks

Create a project in alchemy.io, get the HTTP url and then:

``` bash
$ brownie networks add Development mainnet-fork-dev cmd=ganache-cli host=http://ganache fork=https://eth-mainnet.alchemyapi.io/v2/<api-key-here> accounts=10 mnemonic=brownie port=8545
```

To delete and create Mainnet-fork in Development

```bash
$ brownie networks delete mainnet-fork
$ brownie networks add Development mainnet-fork cmd=ganache-cli host=http://ganache fork=https://eth-mainnet.alchemyapi.io/v2/<api-key-here> accounts=10 mnemonic=brownie port=8545
```
