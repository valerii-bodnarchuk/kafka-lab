# kafka-lab — Stage 0

Single Kafka broker (3.9.0, KRaft mode — no ZooKeeper). One node acts as both broker
and controller.

## Up / down

```sh
make up          # start the broker in the background
docker compose ps  # wait for STATUS = healthy
make down        # stop, keep the data volume
make clean       # stop and delete the data volume
```

## Topics

```sh
./scripts/create-topics.sh   # idempotent: creates `orders` (3 partitions, RF=1)
make topics                  # list
make describe T=orders       # describe one topic
make shell                   # bash inside the container
```

All `kafka-*.sh` commands in the Makefile talk to `localhost:19092` **from inside the
container**, so they never depend on host port mapping.

## Why two listeners

A Kafka client does not keep talking to the address you bootstrap against. The broker
answers metadata requests with its *advertised* address, and the client reconnects
there. So the advertised address has to be resolvable **by the client**, not by the
broker — which means one address is not enough when clients live in two different
networks.

- `PLAINTEXT://kafka:19092` — advertised to clients inside the compose network.
  `kafka` is the service hostname, resolvable only via Docker's DNS.
- `EXTERNAL://localhost:9092` — advertised to clients on the host (published as
  `9092:9092`). `localhost` is meaningless inside the network, but correct from your
  laptop.

A third listener, `CONTROLLER://:9093`, is separate again: it carries the KRaft
metadata quorum (`CONTROLLER_QUORUM_VOTERS: 1@kafka:9093`) and is never advertised to
clients. It is not published to the host.

Using a single listener would force one address to be right in both places, and one
side would always fail to reconnect after bootstrap.
