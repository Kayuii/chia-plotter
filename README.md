# [kayuii/chia-plotter](https://github.com/Kayuii/chia-plotter)

An [chia-plotter](https://github.com/hpool-dev/chia-plotter) docker image.

## Tags

chia-plotter

- `v0.10` ([Dockerfile](https://github.com/Kayuii/chia-plotter/blob/master/hpool/plotter-v0.11/Dockerfile))
- `v0.11` ([Dockerfile](https://github.com/Kayuii/chia-plotter/blob/master/hpool/plotter-v0.11/Dockerfile))

chia-plotter replace ProofOfSpace


- `chiapos-v0.10` ([Dockerfile](https://github.com/Kayuii/chia-plotter/blob/master/hpool/plotter-chiapos-v0.10/Dockerfile))
- `chiapos-v0.11` ([Dockerfile](https://github.com/Kayuii/chia-plotter/blob/master/hpool/plotter-chiapos-v0.11/Dockerfile))

hpool-miner

move to ([kayuii/hpool-miner](https://github.com/Kayuii/hpool-miner))

`docker-compose` example for hpool-miner:

```yml
version: "3"

services:
  miner:
    image: kayuii/hpool-miner:v1.2.0-5
    restart: always
    volumes:
      - /mnt/dst:/mnt/dst
      - /opt/chia/logs:/opt/log
      - /opt/chia/config.yaml:/opt/config.yaml
    command:
      - hpool-chia-miner

```

command-line example:

```sh
docker run -itd --rm  --name miner \
    -v "/mnt/dst:/mnt/dst" \
    -v "/opt/chia/logs:/opt/log" \
    -v "/opt/chia/config.yaml:/opt/config.yaml" \
    kayuii/hpool-miner:v1.2.0-5 hpool-chia-miner
```


command-line example for chia-plotter:

sign
```sh
docker run -it --rm \
  kayuii/chia-plotter:v0.11 chia-plotter-linux-amd64 \
  -action sign -sign-mnemonic "24 mnemonics"
```

plotter
```sh
docker run -itd --rm --name plot00 --cpuset-cpus="0-4" \
  -v "/mnt/tmp/00:/mnt/tmp" \
  -v "/mnt/dst/00:/mnt/plot" \
  -v "/opt/chialogs:/mnt/logs" \
  kayuii/chia-plotter:v0.11 bash -c "sleep 30m && chia-plotter-linux-amd64 -action plotting -plotting-fpk '0x9480b07ff8e454f10d0224135c71dc47fa4a3333704cac39d11d4a65db2892c75454b0da0a29fb7cf8777c22166c87b7' -plotting-ppk '0x96d4d710f722d6957149fb1707b9e915611ee91e485bd26de155ce2b95df8807cd2781736162e71240caf7fff952f709' -plotting-n 1 -r 5 -b 4608 -e -p -d /mnt/plot -t /mnt/tmp |tee /mnt/logs/chia_00.log"
```


checkplot
- `checkplot` ([entrypoint.sh](https://github.com/Kayuii/chia-plotter/blob/master/checkplot/entrypoint.sh))
```sh
./entrypoint.sh check /mnt/dst
```
