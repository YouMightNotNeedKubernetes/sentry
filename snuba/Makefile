docker_stack_name := sentry
docker_stack_svr := snuba

configs:
	@echo "make[-]: No configs available for this stack."

deploy:
	@docker stack deploy --resolve-image=never -c docker-compose.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

migrations:
	@docker stack deploy --resolve-image=never -c docker-compose.bootstrap.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)
	@echo "make[-]: Waiting for bootstrap to complete..."
	@sleep 30
	@docker stack deploy --resolve-image=never -c docker-compose.migrations.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)
	@echo "make[-]: Waiting for migrations to complete..."
	@sleep 30
	@docker stack deploy --resolve-image=never -c docker-compose.create-kafka-topics.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)
	@echo "make[-]: Waiting for create-kafka-topics to complete..."
	@sleep 30

destroy:
	@docker stack rm $(docker_stack_name)_$(docker_stack_svr)
