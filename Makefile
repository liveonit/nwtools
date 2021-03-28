include version.ini
export

.PHONY: build push
build:
	docker build -t ibarretorey/nwtools:${version} -t ibarretorey/nwtools:latest .
run_tests:
	docker run --rm -it -v $(shell pwd)/:/tmp ibarretorey/nwtools:${version} bash -c "cd tmp && sh tests.sh"
push:
	docker push ibarretorey/nwtools:${version}
	docker push ibarretorey/nwtools:latest
