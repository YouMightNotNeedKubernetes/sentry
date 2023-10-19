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
$(1)/deploy:
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

# Primary tasks
deploy: \
	dev/deploy \
	jobs/deploy \
	snuba/deploy \
	symbolicator/deploy \
	vroom/deploy \
	sentry/deploy \
	relay/deploy

destroy: \
	relay/destroy \
	sentry/destroy \
	vroom/destroy \
	symbolicator/destroy \
	snuba/destroy \
	jobs/destroy \
	dev/destroy

wal2json:
	@echo "[INFO] Downloading wal2json"
	@curl -L https://github.com/getsentry/wal2json/releases/download/0.0.2/wal2json-Linux-x86_64-glibc.so > dev/services/postgres/wal2json.so
	@echo "[INFO] Downloaded successfully!"
