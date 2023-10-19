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

## Setup

You might need to create swarm-scoped overlay network called `sentry` for all the stacks to communicate if you haven't already.

On the manager node, run the following command:

```
$ docker network create --scope=swarm --driver overlay --attachable sentry
```
### Before we continue

Please peform the following stpes before continuing:

**Generate a secret key for Sentry**

```
$ docker run -it --rm getsentry/sentry:nightly config generate-secret-key
```

Copy the output of the above command and save it to `SENTRY_SECRET_KEY` in `.env`.

**Generate a credentials for Relay**

```
$ docker run -it --rm getsentry/relay:nightly credentials generate --stdout
```

Copy the output json of the above command and save it to `relay/configs/credentials.json`.

### Installation

> WIP
