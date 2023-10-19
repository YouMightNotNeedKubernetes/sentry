# sentry
Docker Stack deployment for Sentry.

```
$ docker network create --scope=swarm --driver overlay --attachable sentry
$ docker run -it --rm getsentry/sentry:nightly config generate-secret-key
$ docker run -it --rm getsentry/relay:nightly credentials generate --stdout
```
