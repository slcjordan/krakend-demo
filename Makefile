
.PHONY: run
run: run-nginx run-auth run-krakend
	docker logs -f krakend

.PHONY: reload
reload: stop run

.PHONY: stop
stop:
	- docker stop mynginx
	- docker stop authserver
	- docker stop krakend

.PHONY: run-nginx
run-nginx: .network
	docker container inspect --format='nginx is {{.State.Status}}' mynginx || docker run --network krakend-demo -p 8123:80 --name mynginx --rm -v ${PWD}:/usr/share/nginx/html:ro -d nginx

.PHONY: run-krakend
run-krakend: .network
	docker container inspect --format='krakend is {{.State.Status}}' krakend || docker run --network krakend-demo -p 8080:8080 --name krakend --rm -v "${PWD}:/etc/krakend/" devopsfaith/krakend run -d -c /etc/krakend/krakend.json

.PHONY: run-auth
run-auth: .network
	docker container inspect --format='auth-server is {{.State.Status}}' authserver || docker run --network krakend-demo -d -p 8090:8090 --name authserver --rm -v ${PWD}:/go/src/github.com/slcjordan/krakend-demo:ro --workdir /go/src/github.com/slcjordan/krakend-demo golang:1.16 go run cmd/auth/main.go

.network:
	docker network create krakend-demo
	@touch $@

