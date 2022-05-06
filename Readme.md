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

## Run test
```bash
$ docker exec -it playground-brownie_bronie-dev_1 bash -c 'cd bw_simple_storage && brownie test --network dev'
```
