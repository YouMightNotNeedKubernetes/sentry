docker_stack_name := sentry
docker_stack_svr := snuba

configs:
	@echo "[SKIP] No configs available for this stack."

deploy:
	@docker stack deploy -c docker-compose.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

destroy:
	docker stack rm $(docker_stack_name)
