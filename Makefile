container_name_php:=playground_whatever

build:
	docker build -t $(container_name_php) -f Dockerfile .
.PHONY: build

start:
	docker run -d -v ${PWD}/:/app:delegated -it --name $(container_name_php) $(container_name_php)
.PHONY: start

login:
	docker exec -it $(container_name_php) sh
.PHONY: login

stop:
	docker stop $(container_name_php)
	docker rm $(container_name_php)
.PHONY: stop
