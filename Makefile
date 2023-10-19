-include .env
docker_stack_name := sentry

# funcs
define create_task
deploy/$(1):
	@echo "[-] Deploying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) deploy docker_stack_name=$(docker_stack_name)
	@echo " - [OK] Deployed successfully!"
destroy/$(1):
	@echo "[-] Destroying stack $(docker_stack_name)_$(1)"
	@$(MAKE) -C $(1) destroy docker_stack_name=$(docker_stack_name)
	@echo " - [OK] Destroyed successfully!"
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
	deploy/dev sleep/15 \
	deploy/jobs sleep/15 \
	deploy/sentry sleep/120 \
	deploy/relay sleep/15 \
	deploy/snuba sleep/120 \
	deploy/symbolicator sleep/15 \
	deploy/vroom

destroy: \
	destroy/dev sleep/15 \
	destroy/jobs sleep/15 \
	destroy/sentry sleep/15 \
	destroy/relay sleep/15 \
	destroy/snuba sleep/15 \
	destroy/symbolicator sleep/15 \
	destroy/vroom

# Utils
sleep/15:
	@echo "[-] Waiting for next task for 15 seconds..."
	@sleep 15

sleep/120:
	@echo "[-] Waiting for next task for 120 seconds..."
	@sleep 120
