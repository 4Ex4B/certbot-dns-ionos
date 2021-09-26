# Certbot DNS Challenge for IONOS

*inspired by [devlix.de](https://www.devlix.de/lets-encrypt-wildcard-zertifikate-mit-ionos-dns-api-erzeugen/) create Let’s Encrypt wildcard certificates with IONOS DNS API* 

## How to use

1. copy the .env.dist template
```shell
$ cp .env.dist .env
```

2. insert your API Key pair from IONOS and your target domain in the .env file

```dotenv
API_KEY=<publicprefix>.<secret>
DOMAIN=<your.domain>
```

3. build the image

```shell
$ make build
```

4. run a dry-run to make sure, everything is working properly

```shell
$ make dry-run
```

5. create the certificates

```shell
$ make run
```

after that your certificates are available under `./certs/live/<your.domain>` 
