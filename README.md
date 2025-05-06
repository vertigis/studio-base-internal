# Studio Base - Installation
_Updated on: Tue May 6 16:40:35 PDT 2025_
- [Links](#links)
- [System Requirements](#system-requirements)
- [Preparation](#preparation)
  - [Account ID and Registry
    Credentials](#account-id-and-registry-credentials)
  - [Linux Machine](#linux-machine)
  - [Front-End URL](#front-end-url)
  - [ArcGIS Portal and Application
    Registration](#arcgis-portal-and-application-registration)
  - [Get the Package](#get-the-package)
- [On Linux: Initial Setup](#on-linux-initial-setup)
- [On Linux: Upgrade to Latest](#on-linux-upgrade-to-latest)
- [On Windows: Initial Setup](#on-windows-initial-setup)
- [On Windows: Login via SSH](#on-windows-login-via-ssh)
  - [Continue Setup on Linux](#continue-setup-on-linux)
- [Port Management](#port-management)
  - [Bring you own Reverse Proxy](#bring-you-own-reverse-proxy)
  - [Leverage the HTTPS Feature](#leverage-the-https-feature)
  - [Give the Container a Real Web
    Certificate](#give-the-container-a-real-web-certificate)
- [Using Studio as a Reverse Proxy](#using-studio-as-a-reverse-proxy)

## Links

- [This
  Release](https://github.com/vertigis/studio-base-internal/releases/v14871829348-master)
  ( v14871829348-master )
  - [Image](https://github.com/vertigis/studio-base-internal/pkgs/container/studio%2fbase%2finternal/409806957?tag=v14871829348-master)
  - [Installation Guide](https://github.com/)
  - [Deployment Package
    (ZIP)](https://github.com/vertigis/studio-base-internal/archive/refs/tags/v0-pr-13249732233.zip)
  - [Deployment Package
    (TGZ)](https://github.com/vertigis/studio-base-internal/archive/refs/tags/v0-pr-13249732233.tar.gz)
- [Releases](https://github.com/vertigis/studio-base-internal/releases)
- [Images](https://github.com/vertigis/studio-base-internal/pkgs/container/studio%2fbase%2finternal)
- [Repository](https://github.com/vertigis/studio-base-internal)
- [Site](https://vertigis.github.io/studio-base-internal/)

## System Requirements

| Requirement  | Spec                                                |
|--------------|-----------------------------------------------------|
| OS           | Linux                                               |
| Distribution | Ubuntu 24.04, Ubuntu 22.04, or Debian 12 (bookworm) |
| Memory       | 4 GB Minimum, 8 GB Preferred                        |
| Disk         | 16 GB Free                                          |

## Preparation

In order to run VertiGIS Studio in containers, there are a few
prerequisites that should be satisfied. Before you begin, please have
the following at hand:

### Account ID and Registry Credentials

We require an appropriate license to run our software, but also, you
will need registry credentials to pull down the software. Our support
can help you with finding the following information:

- VertiGIS Account ID
- VertiGIS Docker Registry Login Credentials

### Linux Machine

We require Linux to run VertiGIS Studio in containers. You will need to
have a suitable distribution/version of Linux installed on an
appropriately resourced machine. Please review the system requirements.
We suggest using said Linux machine as a pure Docker host. In other
words, do not install software directly on the host system.

### Front-End URL

As with all web software, you will need to know the front-end URL of
where you plan to host the software. Various components need to know
this value.

### ArcGIS Portal and Application Registration

Go to your portal and create a web application:

- Register this application (enable OAUTH2)
- Provide a Redirect URL (use the Front-End URL)
- Note the App ID

### Get the Package

``` sh
# Using bash on Debian/Ubuntu
> mkdir -p deploy-studio
> cd deploy-studio
> curl -fsSL https://github.com/vertigis/studio-base-internal/archive/refs/tags/v14871829348-master.tar.gz | tar -xz

# Using cmd on Windows
> mkdir deploy-studio
> cd deploy-studio
> curl -fsSL https://github.com/vertigis/studio-base-internal/archive/refs/tags/v14871829348-master.tar.gz -o deploy.tar.gz
> tar -xzf deploy.tgz
> del deploy.tgz

# Using powershell on Windows
> mkdir deploy-studio
> cd deploy-studio
> iwr -Uri https://github.com/vertigis/studio-base-internal/archive/refs/tags/v14871829348-master.zip -OutFile deploy.zip
> exa -Path deploy.zip -DestinationPath .
> del deploy.zip

# Using git
> git clone --depth 1 --branch v14871829348-master https://github.com/vertigis/studio-base-internal deploy-studio
> cd deploy-studio
```

## On Linux: Initial Setup

``` bash
# Install Docker and supporting tools if needed
> sudo ./install-tools.sh
> exec sudo su - $USER

# Edit configuration for VertiGIS Studio
# If using a plain terminal, try one of these:
> nano docker-compose.yaml
> vi docker-compose.yaml
# If using a GUI, try one of these:
> code docker-compose.yaml &
> gedit docker-compose.yaml &
> kate docker-compose.yaml &
> mousepad docker-compose.yaml &

# Gain access to images
> gh auth login -w -s repo,read:packages
> gh auth token | docker login ghcr.io -u x-access-token --password-stdin

# Pull/Start VertiGIS Studio
> docker compose up --wait
```

## On Linux: Upgrade to Latest

``` bash
# If login has expired, gain access to images
> docker login ghcr.io -u x-access-token

# Pull down VertiGIS Studio
> docker compose pull

# Upgrade VertiGIS Studio
> docker compose up --wait

# Refresh configuration 
> docker exec vs-studio-main-1 util-refresh
```

## On Windows: Initial Setup

``` powershell
# ADMIN: Install required tools
> .\install-tools.ps1

# Extract CA certificates from Active Directory
# Some environments may use an internal CA system.
# This will enable systems to communicate over HTTPS in this situation.
> .\extract-ca-certs.ps1

# Edit configuration for VertiGIS Studio
> code docker-compose.yaml
> notepad docker-compose.yaml

# Create SSH key if not already done -- use defaults
> ssh-keygen -t ed25519

# Enable passwordless SSH
> .\rsat-auth.ps1 user@linux.contoso.com
```

## On Windows: Login via SSH

``` powershell
# Transfer context to remote deploy-studio folder.
> .\rsat-transfer.ps1 user@linux.contoso.com deploy-studio
```

### Continue Setup on Linux

- [Initial Setup](#on-linux-initial-setup)
- [Upgrade to Latest](#on-linux-upgrade-to-latest)

## Port Management

The Studio image will provide HTTP access (container port 8080) and
HTTPS access (container port 8443). You may map these ports however you
like on the host machine (see configuration).

### Bring you own Reverse Proxy

If you wish to use your own reverse proxy, you will want to expose the
container via non-standard ports. Afterwards, you will need to configure
your reverse proxy to route to one of these ports. Remember to give the
container a certificate if you plan to route to the HTTPS port.

### Leverage the HTTPS Feature

If you wish, you may leverage the HTTPS port directly and route the
standard HTTPS port (443) to the container port (8443).

### Give the Container a Real Web Certificate

The container is setup to use SSL certificates if provided. You have a
few options for certificate issuance:

- For Windows Enterprise environments, use a `.pfx` file:
  - Get the `.pfx` file:
    - Ask your Enterprise Admin for help
    - Use the CA Enrollment Services and export to a `.pfx` file
  - Place the `.pfx` file in `certs-web/my-server.pfx`
  - Run the `convert-pfx.sh` facility to extract the certificate and
    private key
  - Update the compose file:
    - Set the `WEB_CERT` environment value to `my-server`
  - Refresh your deployment (see [here](#on-linux-upgrade-to-latest))
- Using Let’s Encrypt `certbot`:
  - Use `certbot` normally with the `--standalone` option
    - Requires public connectivity and a non-private DNS name
  - Use `certbot` with the `--server` option
    - For Windows Enterprise environments, enable the ACME service in
      the CA
    - You may bring your own ACME-enabled solution
  - Update the compose file:
    - Set the `WEB_CERT` environment value to
      `certbot/my-server.domain.com`
  - From here on, you may use `certbot renew` for renewing the
    certificate
  - Refresh your deployment (see [here](#on-linux-upgrade-to-latest))

## Using Studio as a Reverse Proxy

For convenience, the Studio image provides a means of using the internal
NGINX server as a reverse proxy. You can take advantage of this for
whatever needs you have:

- Modify `nginx-server/nginx.conf` file
- Refresh your deployment (see [here](#on-linux-upgrade-to-latest))
