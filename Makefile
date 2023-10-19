-include .env.docker
-include .env
docker_stack_name := sentry

# funcs
define create_task
$(1)/deploy:
	@echo "[INFO] Deploying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) deploy docker_stack_name=$(docker_stack_name)
	@echo "[INFO] Deployed successfully!"
	@echo
$(1)/destroy:
	@echo "[INFO] Destroying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) destroy docker_stack_name=$(docker_stack_name)
	@echo "[INFO] Destroyed successfully!"
	@echo
endef
define create_migration_task
$(1)/migration:
	@echo "[INFO] Running stack migration $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) migration docker_stack_name=$(docker_stack_name)
	@echo "[INFO] Stack migration successfully!"
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
$(eval $(call create_migration_task,sentry))
$(eval $(call create_task,relay))
$(eval $(call create_task,ingress))

# Primary tasks
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

dev/pull:
	@echo "Pulling development images..."
	docker pull ${EXIM4_IMAGE}
	docker pull ${MEMCACHED_IMAGE}
	docker pull ${REDIS_IMAGE}
	docker pull ${POSTGRES_IMAGE}
	docker pull ${KAFKA_IMAGE}
	docker pull ${CLICKHOUSE_IMAGE}

sentry/pull:
	@echo "Pulling sentry images"
	docker pull ${SENTRY_IMAGE}
	docker pull ${SNUBA_IMAGE}
	docker pull ${RELAY_IMAGE}
	docker pull ${SYMBOLICATOR_IMAGE}
	docker pull ${VROOM_IMAGE}
