include version.ini
export

.PHONY: build push
build:
	docker build -t ibarretorey/nwtools:${version} -t ibarretorey/nwtools:latest .
push:
	docker push ibarretorey/nwtools:${version}
	docker push ibarretorey/nwtools:latest
