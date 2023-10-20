docker_stack_name := sentry
docker_stack_svr := symbolicator

configs:
	@echo "make[-]: No configs available for this stack."

deploy:
	@docker stack deploy --resolve-image=never -c docker-compose.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

destroy:
	@docker stack rm $(docker_stack_name)_$(docker_stack_svr)
