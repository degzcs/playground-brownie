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
$ docker exec -it playground-brownie_bronie-dev_1 bash -c 'cd bw_simple_storage && brownie test --network dev'
```

## Networks

The Dockerfile will add the `test` network to connect to the docker-service called `ganache`.

To connect to ganach UI from docker you will have to add this network:

NOTE: the port and chainid can change.

```bash
$  brownie networks add Ethereum ganache-local host=http://host.docker.internal:7545 chainid=5777 
```
