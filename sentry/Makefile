docker_stack_name := sentry
docker_stack_svr := sentry

.PHONY: configs
configs: configs/config.yml configs/sentry.conf.py

configs/config.yml:
	cp configs/config.yml.example configs/sentry.yml

configs/sentry.conf.py:
	cp configs/sentry.conf.example.py configs/sentry.conf.py

deploy:
	@docker stack deploy --resolve-image=never -c docker-compose.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

migrations:
	@docker stack deploy --resolve-image=never -c docker-compose.migrations.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

credentials:
	@docker stack deploy --resolve-image=never -c docker-compose.credentials.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

destroy:
	@docker stack rm $(docker_stack_name)_$(docker_stack_svr)
