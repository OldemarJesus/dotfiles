# Podman

## Installation

```
yay -S aardvark-dns netavark podman podman-compose
```

## Configuration

**Registries**

File <code>/etc/containers/registries.conf.d/10-unqualified-search-registries.conf</code>:

```
unqualified-search-registries = ["docker.io"]
```

**Setting user**

```
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 podmanuser
```

After rebooting the system, propagate those changes:

```
podman system migrate
```
