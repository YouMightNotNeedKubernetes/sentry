-include .env.docker
-include .env
docker_stack_name := sentry

it:
	@echo "make[-]: Creating swarm-scoped network for sentry"
	@{ docker network create --scope=swarm --driver overlay --attachable sentry && echo "make[-]: Network created successfully!"; } || { echo "[IGNORE] Network already exists"; }

# funcs
define create_task
.PHONY: $(1)/configs
$(1)/configs:
	@echo "make[-]: Creating stack $(docker_stack_name)_$(1) configuration files"
	@$(MAKE) -C $(1) configs
	@echo
$(1)/deploy:
	@echo "make[-]: Deploying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) deploy docker_stack_name=$(docker_stack_name)
	@echo
$(1)/destroy:
	@echo "make[-]: Destroying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) destroy docker_stack_name=$(docker_stack_name)
	@echo
endef
define create_migration_task
$(1)/migration:
	@echo "make[-]: Running stack migration $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) migration docker_stack_name=$(docker_stack_name)
	@echo
endef
define create_credentials_task
$(1)/credentials:
	@echo "make[-]: Running stack credentials creation $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) credentials docker_stack_name=$(docker_stack_name)
	@echo
endef

# Create tasks
$(eval $(call create_task,dev))
$(eval $(call create_task,jobs))
$(eval $(call create_task,snuba))
$(eval $(call create_migration_task,snuba))
$(eval $(call create_task,symbolicator))
$(eval $(call create_task,vroom))
$(eval $(call create_task,sentry))
$(eval $(call create_credentials_task,sentry))
$(eval $(call create_migration_task,sentry))
$(eval $(call create_task,relay))
$(eval $(call create_task,ingress))

# Primary tasks
configs: \
	snuba/configs \
	sentry/configs \
	relay/configs \

migration: \
	snuba/migration \
	sentry/migration

deploy: \
	jobs/deploy \
	snuba/deploy \
	symbolicator/deploy \
	vroom/deploy \
	sentry/deploy \
	relay/deploy \
	ingress/deploy

destroy: \
	ingress/destroy \
	relay/destroy \
	sentry/destroy \
	vroom/destroy \
	symbolicator/destroy \
	snuba/destroy \
	jobs/destroy \
	dev/destroy

dev/pull: sentry/pull
	@echo "Pulling development images..."
	docker pull ${EXIM4_IMAGE}
	docker pull ${MEMCACHED_IMAGE}
	docker pull ${REDIS_IMAGE}
	docker pull ${POSTGRES_IMAGE}
	docker pull ${KAFKA_IMAGE}
	docker pull ${CLICKHOUSE_IMAGE}

sentry/pull:
	@echo "Pulling sentry images"
	docker pull ${NGINX_IMAGE}
	docker pull ${SENTRY_IMAGE}
	docker pull ${SNUBA_IMAGE}
	docker pull ${RELAY_IMAGE}
	docker pull ${SYMBOLICATOR_IMAGE}
	docker pull ${VROOM_IMAGE}
