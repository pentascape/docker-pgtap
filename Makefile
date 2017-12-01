NAME = pentascape/pgtap:0.98.0

all: build

build:
	docker build -t $(NAME) .

push:
	docker push $(NAME)

.PHONY: all build
