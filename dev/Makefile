docker_stack_name := sentry
docker_stack_svr := dev

configs:
	@echo "[SKIP] No configs available for this stack."

deploy: wal2json
	@docker stack deploy --resolve-image=never -c docker-compose.yml --with-registry-auth $(docker_stack_name)_$(docker_stack_svr)

destroy:
	@docker stack rm $(docker_stack_name)_$(docker_stack_svr)

wal2json:
	@echo "[INFO] Downloading wal2json"
	@curl -L https://github.com/getsentry/wal2json/releases/download/0.0.2/wal2json-Linux-x86_64-glibc.so > dev/services/postgres/wal2json.so
	@echo "[INFO] Downloaded successfully!"
