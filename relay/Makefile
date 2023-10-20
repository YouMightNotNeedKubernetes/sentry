docker_stack_name := sentry
docker_stack_svr := relay

.PHONY: configs
configs: \
	configs/config.yml \
	configs/credentials.json

configs/config.yml:
	cp configs/config.example.yml configs/config.yml

configs/credentials.json:
	@docker run -it --rm -v $(CURDIR)/configs:/relay --workdir=/relay getsentry/relay:nightly credentials generate

deploy:
	@docker stack deploy --resolve-image=never -c docker-compose.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

destroy:
	@docker stack rm $(docker_stack_name)_$(docker_stack_svr)
