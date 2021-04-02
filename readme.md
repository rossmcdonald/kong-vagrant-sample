# Kong EE CentOS Installation

Prerequisites:

- For ease of use, this is packaged as a [vagrant](https://www.vagrantup.com/) configuration. To install vagrant on macOS with homebrew, run `brew install vagrant`.
- If you want to create workspaces, you'll need to put a `konnect-license.json` file in the root of the repo.

> Note that the `Vagrantfile` and accompanying setup is specifically tailored for CentOS 7. Other distributions or versions will not work.

To start the VM, run:

```sh
vagrant up
```

This will install, configure, and start the base Kong EE installation. Once started, you can configure the runtime settings (users, services, etc) by running:

```sh
# make sure `konnect-license.json` file is present!

./configure_kong.sh

# optionally, to enable soap transformer plugin
./enable_soap_plugin.sh
```

Once done, there will be 3 workspaces, 2 users, 2 services, and 2 routes all pre-configured. You can then access Kong via:

- Gateway - http://localhost:7000
- Admin API - http://localhost:7001
- Manager - http://localhost:7002
- Dev Portal - http://localhost:7003

## Troubleshooting

### Reloading the Kong Configuration

To reload the Kong config:

```sh
/usr/local/bin/kong reload -c /etc/kong/kong.conf
```

### Finding Logs

To tail the access logs:

```sh
tail -f /usr/local/kong/logs/access.log
```

Or better yet:

```
tail -f /usr/local/kong/logs/*
```

All logs are stored under `/usr/local/kong/logs`.
