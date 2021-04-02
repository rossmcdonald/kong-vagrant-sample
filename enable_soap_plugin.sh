#!/bin/bash

# clone down plugin if not already available
if [[ ! -d kong-plugin-soap-request-transformer ]]; then
    git clone https://github.com/Kong/kong-plugin-soap-request-transformer
    cd kong-plugin-soap-request-transformer && git checkout ross-changes
    cd ..
fi

# install plugin to lua path
vagrant ssh -c "cd /vagrant/kong-plugin-soap-request-transformer && sudo /usr/local/bin/luarocks make"

curl -sL localhost:7001 | jq . | grep soap &>/dev/null
if [[ $? -ne 0 ]]; then
    # if soap is not present in the response, enable it
    vagrant ssh -c "sudo sed -i 's/#plugins = .*/plugins = /' /etc/kong/kong.conf"
    vagrant ssh -c "sudo sed -i 's/plugins = .*/plugins = bundled,soap-request-transformer/' /etc/kong/kong.conf"
    vagrant ssh -c "sudo /usr/local/bin/kong restart -c /etc/kong/kong.conf"
fi

if [[ ! -f soap-test-env.yml ]]; then
    exit 0
fi

# apply test config
deck sync -s soap-test-env.yml --kong-addr http://localhost:7001
if [[ $? -ne 0 ]]; then
    count=0
    while :; do
        deck sync -s soap-test-env.yml --kong-addr http://localhost:7001
        if [[ $? -eq 0 ]]; then
            break
        fi
        count=$count+1
        if [[ count > 5 ]]; then
            break
        fi
    done
fi

echo -e "Run the following command to demonstrate functionality:\n\ncurl -sL localhost:7000/getquotes -H \"Accept: application/json\""
