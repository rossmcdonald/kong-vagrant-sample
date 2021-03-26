# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.network "forwarded_port", guest: 8000, host: 7000 # gateway
  config.vm.network "forwarded_port", guest: 8001, host: 7001 # admin api
  config.vm.network "forwarded_port", guest: 8002, host: 7002 # manager
  config.vm.network "forwarded_port", guest: 8003, host: 7003 # dev portal

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "shell", inline: <<-SHELL
    set -x
    install -D -m644 -C /vagrant/kong.repo /etc/yum.repos.d/kong.repo
    yum update -y
    yum install kong-enterprise-edition -y

    yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y
    yum install postgresql96 postgresql96-server -y

    /usr/pgsql-9.6/bin/postgresql96-setup initdb
    systemctl enable postgresql-9.6
    systemctl start postgresql-9.6
    sleep 1
    sudo -u postgres psql -c "CREATE USER kong"
    sudo -u postgres psql -c "CREATE DATABASE kong OWNER kong"
    sudo -u postgres psql -c "ALTER USER kong WITH password 'kong'"
    sed -i "s/host.*all.*all.*127.0.0.1\\/32.*ident/host\tall\tall\t127.0.0.1\\/32\tmd5/" /var/lib/pgsql/9.6/data/pg_hba.conf
    systemctl restart postgresql-9.6

    cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    sed -i 's/#pg_user = kong/pg_user = kong/' /etc/kong/kong.conf
    sed -i 's/#pg_password = /pg_password = kong/' /etc/kong/kong.conf
    sed -i 's/#pg_database = kong/pg_database = kong/' /etc/kong/kong.conf
    sed -i 's/#admin_listen = 127.0.0.1:8001 reuseport backlog=16384, 127.0.0.1:8444 http2 ssl reuseport backlog=16384/admin_listen = 0.0.0.0:8001 reuseport backlog=16384/' /etc/kong/kong.conf
    sed -i 's/#admin_api_uri =/admin_api_uri = http:\\/\\/localhost:7001/' /etc/kong/kong.conf
    sed -i 's/#enforce_rbac = off/enforce_rbac = on/' /etc/kong/kong.conf
    sed -i 's/#admin_gui_session_conf = .*/admin_gui_session_conf = {"secret":"secret","storage":"kong","cookie_secure":false}/' /etc/kong/kong.conf
    sed -i 's/#admin_gui_auth = .*/admin_gui_auth = basic-auth/' /etc/kong/kong.conf

    KONG_PASSWORD=password /usr/local/bin/kong migrations bootstrap -c /etc/kong/kong.conf
    /usr/local/bin/kong start -c /etc/kong/kong.conf
  SHELL
end
