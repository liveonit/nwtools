include version.ini
export

.PHONY: build push
build:
	docker build -t ibarretorey/nwtools:${version} -t ibarretorey/nwtools:latest .
run_tests:
	docker run --rm -it -v $(shell pwd)/:/tmp ibarretorey/nwtools:${version} bash -c "cd tmp && sh tests_internal.sh"
	docker run -dt --rm --name nwtools_test -v $(shell pwd)/:/tmp -p 880:80 -p 4443:443 ibarretorey/nwtools:${version}
	sleep 5
	sh tests_external.sh || (docker stop nwtools_test && exit 7)
	docker stop nwtools_test
push:
	docker push ibarretorey/nwtools:${version}
	docker push ibarretorey/nwtools:latest
