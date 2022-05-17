# Brownie Playground
Setup Brownie and Ganache

## Install 
```bash
$ docker-compose up
```

## Run Scripts
One option could be:

```bash
$ docker exec -it playground-brownie_bronie-dev_1 bash
$ cd bw_simple_storage/
$ brownie run deploy.py --network dev
```

## Run tests

```bash
$ docker exec -it playground-brownie_bronie-dev_1 bash -c 'cd bw_simple_storage && brownie test --network test'
```

## Networks

The Dockerfile will add the `test` network to connect to the docker-service called `ganache`.

To connect to ganach UI from docker you will have to add this network:

NOTE: the port and chainid can change.

```bash
$  brownie networks add Ethereum ganache-local host=http://host.docker.internal:7545 chainid=5777 
```

### Fork networks

``` bash
$ brownie networks add Development mainnet-fork-dev cmd=ganache-cli host=http://ganache fork=https://eth-mainnet.alchemyapi.io/v2/<api-key-here> accounts=10 mnemonic=brownie port=8545
```

to delete and create Mainnet-fork in Development

```bash
$ brownie networks delete mainnet-fork 
$ brownie networks add Development mainnet-fork cmd=ganache-cli host=http://ganache fork=https://eth-mainnet.alchemyapi.io/v2/<api-key-here> accounts=10 mnemonic=brownie port=8545
```
