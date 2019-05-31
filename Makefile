PRESTO_VERSION := 311
PRESTO_SNAPSHOT_VERSION := 312-SNAPSHOT

build:
	docker build --build-arg VERSION=${PRESTO_VERSION} -t lewuathe/presto-base:${PRESTO_VERSION} presto-base
	docker build --build-arg VERSION=${PRESTO_VERSION} -t lewuathe/presto-coordinator:${PRESTO_VERSION} presto-coordinator
	docker build --build-arg VERSION=${PRESTO_VERSION} -t lewuathe/presto-worker:${PRESTO_VERSION} presto-worker
	PRESTO_VERSION=$(PRESTO_VERSION) docker-compose build

local:
	docker build --build-arg VERSION=${PRESTO_SNAPSHOT_VERSION} -f presto-base/Dockerfile-dev -t lewuathe/presto-base:${PRESTO_SNAPSHOT_VERSION} presto-base
	docker build --build-arg VERSION=${PRESTO_SNAPSHOT_VERSION} -t lewuathe/presto-coordinator:${PRESTO_SNAPSHOT_VERSION} presto-coordinator
	docker build --build-arg VERSION=${PRESTO_SNAPSHOT_VERSION} -t lewuathe/presto-worker:${PRESTO_SNAPSHOT_VERSION} presto-worker

.PHONY: test clean

push: build
	docker push lewuathe/presto-base:$(PRESTO_VERSION)
	docker push lewuathe/presto-coordinator:$(PRESTO_VERSION)
	docker push lewuathe/presto-worker:$(PRESTO_VERSION)

run:
	
	PRESTO_VERSION=$(PRESTO_VERSION) docker-compose up -d
	echo "Please check http://localhost:8080"

down:
	PRESTO_VERSION=$(PRESTO_VERSION) docker-compose down
