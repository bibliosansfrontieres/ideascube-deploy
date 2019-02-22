# Ideascube deploy

This set of roles and tasks hack and configure a CMAL device with belena-engine (Moby-based container engine) and pull Docker images like Ideascube, Kiwix, Kolibri, traefik, etc.


## Initialization

```
curl -sfL https://github.com/bibliosansfrontieres/ideascube-deploy/raw/master/ideascube_setup.sh | bash -s -- --name idc-fra-name
```

## Update Docker images

```
curl -sfL https://github.com/bibliosansfrontieres/ideascube-deploy/raw/master/ideascube_setup.sh | bash -s -- --update containers
```

## Update ideascube content

```
curl -sfL https://github.com/bibliosansfrontieres/ideascube-deploy/raw/master/ideascube_setup.sh | bash -s -- --update content
```
