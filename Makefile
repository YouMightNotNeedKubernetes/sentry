-include .env
docker_stack_name := sentry

# funcs
define create_task
deploy/$(1):
	@echo "[INFO] Deploying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) deploy docker_stack_name=$(docker_stack_name)
	@echo "[INFO] Deployed successfully!"
	@echo
destroy/$(1):
	@echo "[INFO] Destroying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) destroy docker_stack_name=$(docker_stack_name)
	@echo "[INFO] Destroyed successfully!"
	@echo
endef

# Create tasks
$(eval $(call create_task,dev))
$(eval $(call create_task,jobs))
$(eval $(call create_task,relay))
$(eval $(call create_task,sentry))
$(eval $(call create_task,snuba))
$(eval $(call create_task,symbolicator))
$(eval $(call create_task,vroom))

# Primary tasks
deploy: \
	deploy/dev 
	deploy/jobs \
	deploy/sentry \
	deploy/relay \
	deploy/snuba \
	deploy/symbolicator \
	deploy/vroom

destroy: \
	destroy/dev \
	destroy/jobs \
	destroy/sentry \
	destroy/relay \
	destroy/snuba \
	destroy/symbolicator \
	destroy/vroom
