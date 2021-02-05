# Bitnami Docker Image for SuiteCRM

## What is SuiteCRM?

> SuiteCRM is a completely open source enterprise-grade Customer Relationship Management (CRM) application. SuiteCRM is a software fork of the popular customer relationship management (CRM) system SugarCRM.

[https://www.suitecrm.com/](https://www.suitecrm.com/)

## TL;DR

```console
$ git clone https://github.com/deck-app/suitecrm.git
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/suitecrm?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).


## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.11.18`, `7.11.18-debian-10-r81`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-suitecrm/blob/7.11.18-debian-10-r81/7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/suitecrm GitHub repo](https://github.com/bitnami/bitnami-docker-suitecrm).

## Get this image

The recommended way to get the Bitnami SuiteCRM Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/suitecrm).

```console
$ docker pull bitnami/suitecrm:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/suitecrm/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/suitecrm:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/suitecrm:latest 'https://github.com/bitnami/bitnami-docker-suitecrm.git#master:7/debian-10'
```

## How to use this image

SuiteCRM requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ git clone https://github.com/deck-app/suitecrm.git
$ docker-compose up -d
```

### Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

#### Step 1: Create a network

```console
$ docker network create suitecrm-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_suitecrm \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_suitecrm \
  --network suitecrm-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for SuiteCRM persistence and launch the container

```console
$ docker volume create --name suitecrm_data
$ docker run -d --name suitecrm \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env SUITECRM_DATABASE_USER=bn_suitecrm \
  --env SUITECRM_DATABASE_PASSWORD=bitnami \
  --env SUITECRM_DATABASE_NAME=bitnami_suitecrm \
  --network suitecrm-network \
  --volume suitecrm_data:/bitnami/suitecrm \
  bitnami/suitecrm:latest
```

Access your application at *http://your-ip/*


> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Restoring persisted SuiteCRM installation

The entire directory of the SuiteCRM application will be persisted. To update the application, you will need to do it manualy.
SuiteCRM does not offer any out-of-the-box tool to upgrade the database schema after an upgrade, so it will not be done automatically.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create suitecrm-network
```

#### Step 2. Create a MariaDB container with host volume

```console
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_suitecrm \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_suitecrm \
  --network suitecrm-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the SuiteCRM the container with host volumes

```console
$ docker volume create --name suitecrm_data
$ docker run -d --name suitecrm \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env SUITECRM_DATABASE_USER=bn_suitecrm \
  --env SUITECRM_DATABASE_PASSWORD=bitnami \
  --env SUITECRM_DATABASE_NAME=bitnami_suitecrm \
  --network suitecrm-network \
  --volume /path/to/suitecrm-persistence:/bitnami/suitecrm \
  bitnami/suitecrm:latest
```

## Configuration

## Environment variables

When you start the SuiteCRM image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/docker-compose.yml) file present in this repository:

```yaml
suitecrm:
  ...
  environment:
    - SUITECRM_PASSWORD=my_password
  ...
```

 * For manual execution add a `--env` option with each variable and value:

  ```console
  $ docker run -d --name suitecrm -p 80:8080 -p 443:8443 \
    --env SUITECRM_PASSWORD=my_password \
    --network suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

Available environment variables:

##### User and Site configuration

- `APACHE_HTTP_PORT_NUMBER`: Port used by Apache for HTTP. Default: **8080**
- `APACHE_HTTPS_PORT_NUMBER`: Port used by Apache for HTTPS. Default: **8443**
- `SUITECRM_USERNAME`: SuiteCRM application username. Default: **user**
- `SUITECRM_PASSWORD`: SuiteCRM application password. Default: **bitnami**
- `SUITECRM_EMAIL`: SuiteCRM application email. Default: **user@example.com**
- `SUITECRM_SKIP_BOOTSTRAP`: Whether to perform initial bootstrapping for the application. Default: **no**
- `SUITECRM_HOST`: Host where SuiteCRM will be running. Default:**localhost**.
- `SUITECRM_ENABLE_HTTPS`: Whether to use HTTPS by default. Default: **no**.
- `SUITECRM_EXTERNAL_HTTP_PORT_NUMBER`: Port to used by SuiteCRM to generate URLs and links when accessing using HTTP. Default **80**.
- `SUITECRM_EXTERNAL_HTTPS_PORT_NUMBER`: Port to used by SuiteCRM to generate URLs and links when accessing using HTTPS. Default **443**.

##### Use an existing database

- `SUITECRM_DATABASE_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `SUITECRM_DATABASE_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `SUITECRM_DATABASE_NAME`: Database name that SuiteCRM will use to connect with the database. Default: **bitnami_suitecrm**
- `SUITECRM_DATABASE_USER`: Database user that SuiteCRM will use to connect with the database. Default: **bn_suitecrm**
- `SUITECRM_DATABASE_PASSWORD`: Database password that SuiteCRM will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for SuiteCRM using mysql-client

- `MYSQL_CLIENT_DATABASE_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MYSQL_CLIENT_DATABASE_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MYSQL_CLIENT_DATABASE_ROOT_USER`: Database admin user. Default: **root**
- `MYSQL_CLIENT_DATABASE_ROOT_PASSWORD`: Database password for the database admin user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET`: Character set to use for the new database. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_COLLATE`: Database collation to use for the new database. No defaults.
- `MYSQL_CLIENT_ENABLE_SSL_WRAPPER`: Whether to force SSL connections to the database via the `mysql` CLI tool. Useful for applications that rely on the CLI instead of APIs. Default: **no**
- `MYSQL_CLIENT_ENABLE_SSL`: Whether to force SSL connections for the database. Default: **no**
- `MYSQL_CLIENT_SSL_CA_FILE`: Path to the SSL CA file for the new database. No defaults
- `MYSQL_CLIENT_SSL_CERT_FILE`: Path to the SSL CA file for the new database. No defaults
- `MYSQL_CLIENT_SSL_KEY_FILE`: Path to the SSL CA file for the new database. No defaults
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### SMTP Configuration

To configure SuiteCRM to send email using SMTP you can set the following environment variables:

- `SUITECRM_SMTP_HOST`: SMTP host.
- `SUITECRM_SMTP_PORT`: SMTP port.
- `SUITECRM_SMTP_USER`: SMTP account user.
- `SUITECRM_SMTP_PASSWORD`: SMTP account password.
- `SUITECRM_SMTP_PROTOCOL`: SMTP protocol to use.
- `SUITECRM_SMTP_NOTIFY_NAME`: Name to use in the SMTP notifications
- `SUITECRM_SMTP_NOTIFY_ADDRESS`: Notify address for SMTP notifications

##### PHP configuration

- `PHP_EXPOSE_PHP`: Enables HTTP header with PHP version. No default.
- `PHP_MAX_EXECUTION_TIME`: Maximum execution time for PHP scripts. No default.
- `PHP_MAX_INPUT_TIME`: Maximum input time for PHP scripts. No default.
- `PHP_MAX_INPUT_VARS`: Maximum amount of input variables for PHP scripts. No default.
- `PHP_MEMORY_LIMIT`: Memory limit for PHP scripts. Default: **256M**
- `PHP_POST_MAX_SIZE`: Maximum size for PHP POST requests. **60M**.
- `PHP_UPLOAD_MAX_FILESIZE`: Maximum file size for PHP uploads. **60M**.

##### Example

This would be an example of SMTP configuration using a Gmail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/docker-compose.yml) file present in this repository:

```yaml
  suitecrm:
    ...
    environment:
      - SUITECRM_DATABASE_USER=bn_suitecrm
      - SUITECRM_DATABASE_NAME=bitnami_suitecrm
      - ALLOW_EMPTY_PASSWORD=yes
      - SUITECRM_SMTP_HOST=smtp.gmail.com
      - SUITECRM_SMTP_PROTOCOL=tls
      - SUITECRM_SMTP_PORT=587
      - SUITECRM_SMTP_USER=your_email@gmail.com
      - SUITECRM_SMTP_PASSWORD=your_password
  ...
```
 * For manual execution:

  ```console
  $ docker run -d --name suitecrm -p 80:8080 -p 443:8443 \
    --env SUITECRM_DATABASE_USER=bn_suitecrm \
    --env SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    --env SUITECRM_SMTP_HOST=smtp.gmail.com \
    --env SUITECRM_SMTP_PORT=587 \
    --env SUITECRM_SMTP_PROTOCOL=tls \
    --env SUITECRM_SMTP_USER=your_email@gmail.com \
    --env SUITECRM_SMTP_PASSWORD=your_password \
    --network suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

