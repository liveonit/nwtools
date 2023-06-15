include version.ini
export

.PHONY: build push
build:
	docker build -t liveonit/nwtools:${version} -t liveonit/nwtools:latest .
run_tests:
	docker run --rm -v $(shell pwd)/:/tmp liveonit/nwtools:${version} bash -c "cd tmp && sh tests_internal.sh"
	docker run -d --rm --name nwtools_test -v $(shell pwd)/:/tmp -p 880:80 -p 4443:443 liveonit/nwtools:${version}
	sleep 5
	sh tests_external.sh || (docker stop nwtools_test && exit 7)
	docker stop nwtools_test
push:
	docker push liveonit/nwtools:${version}
	docker push liveonit/nwtools:latest
