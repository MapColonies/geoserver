# GeoServer Openshift Compatible Image

## Why?

`Kartoza/geoserver` image runs the command `VOLUME []` which "locks" the folder and makes it immutable.
Therefore we cant change the owner of the folder to the random generated user which is under the root group.

## What does the script do?

1. Clones `kartoza/geoserver` git repo on default (configurable)
2. Removes the `VOLUME []` command from the Dockerfile
3. Builds the image
4. Builds the openshift compatible image
5. **OPTIONAL** tag image

## Run the script

**DON'T FORGET TO RUN**

```sh
npm i
```

Running the script

```
npx zx index.mjs
```

## Configurable options

| ENV                       | Default Value  | Description                                                          | mandatory? |
| ------------------------- | -------------- | -------------------------------------------------------------------- | ---------- |
| IMAGE_REPO                |                | The name of the docker image                                         | yes        |
| GEOSERVER_VERSION         |                | The `kartoza/geoserver` version                                      | yes        |
| WORK_DIR                  | /tmp/geoserver | The folder where the script clones the `kartoza/geoserver` git repo  | no         |
| IMAGE_DOCKER_REGISTRY     |                | If set it will tag image with the registry prefix                    | no         |
| POSTGRES_ENABLE_SSL_AUTH  |                | If set it will load postgres ssl auth certs to the required location | no         |
| POSTGRES_CERTS_MOUNT_PATH |                | The location where the postgres certs are mounted                    |            |
| ADD_ROOT_CERTS            |                | enable adding certs to geoserver                                     |
| ROOT_CERTS_PATH           |                | path to load the certs from                                          |

## Telemetry and Metrics

Telemetry and metrics are now part of `kartoza/docker-geoserver`. Read more about it [here](https://github.com/kartoza/docker-geoserver/?tab=readme-ov-file#opentelemetry-and-prometheus-jmx-metrics-support)

## Postgres SSL authentication

The required file in order to connect to postgres using ssl mode are as follows:

-   `postgresql.crt`
-   `postgresql.pk8`
-   `root.ca`

To convert a standard private key to PKCS8 you can use the following openssl command:

`openssl pkcs8 -topk8 -inform PEM -outform DER -in postgresql.key -out postgresql.pk8 -nocrypt`

# helm

This repo contains a helm chart to deploy geoserver with reloading configuration to opeshift.

## Why?

Geoserver by nature is a monolithic project that is built to run on VM or a physical machine.
Because we want it to run on k8s, we added a sidecar that enables geoserver to be deployed to k8s without a persistent volume.

## How does it work?

When a new geoserver pod is starting, an init-container that runs the image will download the datadir from S3 for the first time, so geoserver has an initial configuration.
After the init container has finished it job, the geoserver image will start, and a sidecar that will check periodically for changes in S3, and if it detects one, it will download the new one, and apply it to the Geoserver image.

## Logging

-   for custom geoserver logging define your logging schema and place it in `/data_dir/logs/custom_logging.xml` it is possible to log in json format using the `JsonTemplateLayout` [read more](https://logging.apache.org/log4j/2.x/manual/json-template-layout.html)

-   you can set the used logging schema through the geoserver UI under Global-Settings -> Logging Profile or specify it in `/data_dir/logging.xml`

-   in the UI you can also define your wanted requests logging strategy

## Installation

set the values as you please, and run:

```bash
  cd helm
  helm install geoserver .
```
