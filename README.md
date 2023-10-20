> [!WARNING]
> This documentation and stacks are currently a work-in-progress.

<p align="center">
  <p align="center">
    <a href="https://sentry.io/?utm_source=github&utm_medium=logo" target="_blank">
      <img src="https://sentry-brand.storage.googleapis.com/sentry-wordmark-dark-280x84.png" alt="Sentry" width="280" height="84">
    </a>
  </p>
  <p align="center">
    Users and logs provide clues. Sentry provides answers.
  </p>
</p>

## About
Docker Stack deployment for Sentry, feature-complete and packaged up for low-volume deployments and proofs-of-concept.

### What's Sentry?

Sentry is a developer-first error tracking and performance monitoring platform that helps developers see what actually matters, solve quicker, and learn continuously about their applications.

https://develop.sentry.dev/self-hosted/

## Requirements

- Docker Swarm Cluster (with 1 Manager and 5 Worker nodes)
- 2 CPU Cores for each node
- 2 GB RAM for each node
- 20 GB Free Disk Space for each node

## Prerequisites

You need to have the following services running before you can install Sentry:
- redis
- kafka
- postgres
- clickhouse

Set the following environment variables in `.env` file and point them to the correct host:

```sh
# Leave it as show if you plan to use the development stack.
# Otherwise, set it to the external host of each service.
export REDIS_HOST=redis
export CLICKHOUSE_HOST=clickhouse
export KAFKA_DEFAULT_BROKERS="kafka:9092"
```

> ![NOTE]
> If you on plan to run a proof-of-concept, there a development stack which will deploy a single replicas of each service mentioned above.
>
> Run `make dev/deploy` to deploy the development stack.

## Installation

There is not one-click installation for Sentry, but it's not hard to install either. You can install Sentry by following the steps below.

This stack is designed to be easy to understand and extend. It's not meant to be used in production, but it can be used as a starting point for your own production deployment.

You might need to create swarm-scoped overlay network called `sentry` for all the stacks to communicate if you haven't already.

On the manager node, run the following command:

```sh
$ docker network create --scope=swarm --driver overlay --attachable sentry
# or
$ make
```

### Before we continue

Please peform the following stpes before continuing:

**Generate a secret key for Sentry**

```sh
$ docker run -it --rm getsentry/sentry:nightly config generate-secret-key
```

Copy the output of the above command and save it to `SENTRY_SECRET_KEY` in `.env`.

**Generate a credentials for Relay**

```sh
$ docker run -it --rm getsentry/relay:nightly credentials generate --stdout
# or
$ make relay/configs
```

Copy the output json of the above command and save it to `relay/configs/credentials.json`.

**Generate config files for sentry, symbolicator and relay**

```sh
# This command also trigger `relay/configs` recipe.
$ make configs
```

### Configure Sentry

Edit `.env` file and set the following variables:


### Run database migrations and create topic for kafka

The following command will run database migrations and create topic for kafka using the Docker Swarm `replicated-job` deployment.

```sh
$ make migrations
```

> ![NOTE]
> Please give it a few minutes for the database migrations to complete before continuing.
>
> You can check the status of the job by running `docker service logs -f <service>` on the following services:
> - `sentry_sentry_database-migration`
> - `sentry_snuba_snuba-bootstrap`
> - `sentry_snuba_snuba-migrations`
> - `sentry_snuba_create-kafka-topics`
>
> And run `docker service ls` to see if the jobs are still running or complated.

### Deploy Sentry

Run the following command to deploy Sentry and all necessary services:

```sh
$ make deploy
```

> ![NOTE]
> The deployment will take a few minutes to complete. You can check the status of the deployment by running `docker service ls` to check the progress.

#### Create Admin User

Run the following command to create an admin user:

```sh
$ make sentry/credentials
```
