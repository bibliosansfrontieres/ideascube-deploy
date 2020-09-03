# Ideascube deploy

This set of roles and tasks hack and configure a CMAL device with belena-engine (Moby-based container engine) and pull Docker images like Ideascube, Kiwix, Kolibri, traefik, etc.


## Initialization

```
curl -sfL https://github.com/bibliosansfrontieres/ideascube-deploy/raw/master/ideascube_setup.sh | sudo bash -s -- --name idc-fra-name
```

## Update Docker images

```
curl -sfL https://github.com/bibliosansfrontieres/ideascube-deploy/raw/master/ideascube_setup.sh | sudo bash -s -- --update containers
```

## Update ideascube content

```
curl -sfL https://github.com/bibliosansfrontieres/ideascube-deploy/raw/master/ideascube_setup.sh | sudo bash -s -- --update content
```

## Reset a device

Note: the URL is subject to change to the [GitLab repository](https://gitlab.com/bibliosansfrontieres/toolbox/cap/factory-config)
as soon as [Temps Modernes](https://gitlab.com/bibliosansfrontieres/tm/factory_manager)
is updated to use it as well.

```shell
wget https://raw.githubusercontent.com/bibliosansfrontieres/ideascube-deploy/master/reset.sh
bash reset.sh
```

By default this script will keep our remote access means:
* SSH keys
* tinc VPN (configuration, keys)

If you want to remove that also, use the `rm-bsf-access` argument:
```shell
bash reset.sh rm-bsf-access
```
