docker_stack_name := sentry

compose_files := -c docker-compose.yml
# compose_files += -c docker-compose.relay.yml
# compose_files += -c docker-compose.sentry.yml
# compose_files += -c docker-compose.snuba.yml
# compose_files += -c docker-compose.symbolicator.yml
# compose_files += -c docker-compose.vroom.yml
compose_files += -c docker-compose.jobs.yml
# compose_files += -c docker-compose.extras.yml

it:
	@echo "make [deploy|destroy]"

print:
	@docker stack config $(compose_files)

deploy: \
	deploy-dev \
	deploy-default \
	deploy-relay \
	deploy-snuba \
	deploy-symbolicator \
	deploy-vroom \
	deploy-sentry

deploy-default:
	docker stack deploy $(compose_files) --with-registry-auth $(docker_stack_name)_default
	@echo "Preparing next task..."
	@sleep 15
deploy-sentry:
	docker stack deploy -c docker-compose.sentry.yml --with-registry-auth $(docker_stack_name)
	@echo "Preparing next task..."
	@sleep 15
deploy-relay:
	docker stack deploy -c docker-compose.relay.yml --with-registry-auth $(docker_stack_name)_relay
	@echo "Preparing next task..."
	@sleep 15
deploy-snuba:
	docker stack deploy -c docker-compose.snuba.yml --with-registry-auth $(docker_stack_name)_snuba
	@echo "Preparing next task..."
	@sleep 15
deploy-symbolicator:
	docker stack deploy -c docker-compose.symbolicator.yml --with-registry-auth $(docker_stack_name)_symbolicator
	@echo "Preparing next task..."
	@sleep 15
deploy-vroom:
	docker stack deploy -c docker-compose.vroom.yml --with-registry-auth $(docker_stack_name)_vroom
	@echo "Preparing next task..."
	@sleep 15
deploy-dev:
	docker stack deploy -c docker-compose.dev.yml --with-registry-auth $(docker_stack_name)_dev
	@echo "Preparing next task..."
	@sleep 15

destroy:
	docker stack rm \
		$(docker_stack_name)_default \
		$(docker_stack_name) \
		$(docker_stack_name)_relay \
		$(docker_stack_name)_snuba \
		$(docker_stack_name)_symbolicator \
		$(docker_stack_name)_vroom \
		$(docker_stack_name)_dev
