BOOTSTRAP := localhost:19092

.PHONY: up down clean topics describe shell

up:
	docker compose up -d

down:
	docker compose down

clean:
	docker compose down -v

topics:
	docker compose exec kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server $(BOOTSTRAP) --list

describe:
	@test -n "$(T)" || { echo "usage: make describe T=<topic>"; exit 1; }
	docker compose exec kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server $(BOOTSTRAP) --describe --topic $(T)

shell:
	docker compose exec -it kafka bash
