
.PHONY: run
run: run-nginx run-krakend

.PHONY: reload
reload: stop run

.PHONY: stop
stop:
	- docker stop my-nginx
	- docker stop krakend

.PHONY: run-nginx
run-nginx: .network
	docker container inspect --format='krakend is {{.State.Status}}' mynginx || docker run --network krakend-demo -p 8123:80 --name mynginx --rm -v ${PWD}:/usr/share/nginx/html:ro -d nginx

.PHONY: run-krakend
run-krakend: .network
	docker container inspect --format='krakend is {{.State.Status}}' krakend || docker run --network krakend-demo -d -p 8080:8080 --name krakend --rm -v "${PWD}:/etc/krakend/" devopsfaith/krakend run -d -c /etc/krakend/krakend.json

.network:
	docker network create krakend-demo
	@touch $@

