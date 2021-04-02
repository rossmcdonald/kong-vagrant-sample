#!/bin/bash

host="localhost:7001"
# common_args=" -H \"Content-Type: application/json\" -H \"Kong-Admin-Token:password\" "
common_args=" -H \"Content-Type: application/json\" "

# register license
curl -XPOST \
    $host/licenses \
    -H "Content-Type: application/json" \
    -d "{\"payload\": \"$(cat konnect-license.json | sed 's/"/\\"/g')\" }"

# # create workspace 1
# curl -XPOST \
#     $host/workspaces \
#     -H "Content-Type: application/json"
#     -d "{\"name\":\"TeamA\",\"meta\":{\"color\":\"#C9604C\"}}"

# # create workspace 2
# curl -XPOST \
#     $host/workspaces \
#     -H "Content-Type: application/json"
#     -d "{\"name\":\"TeamB\",\"meta\":{\"color\":\"#C960FF\"}}"

# # create role for workspace 1
# curl -XPOST \
#     $host/TeamA/rbac/roles \
#     -H "Content-Type: application/json"
#     -d "{\"name\":\"workspace-super-admin\"}"
# curl -XPOST \
#     $host/TeamA/rbac/roles/$(curl $host/TeamA/rbac/roles $common_args | jq '.data[0].id' | xargs)/endpoints \
#     -H "Content-Type: application/json"
#     -d "{\"endpoint\":\"*\",\"actions\":\"create,update,read,delete\",\"negative\":false}"

# # create role for workspace 2
# curl -XPOST \
#     $host/TeamB/rbac/roles \
#     -H "Content-Type: application/json"
#     -d "{\"name\":\"workspace-super-admin\"}"
# curl -XPOST \
#     $host/TeamB/rbac/roles/$(curl $host/TeamB/rbac/roles $common_args | jq '.data[0].id' | xargs)/endpoints \
#     -H "Content-Type: application/json"
#     -d "{\"endpoint\":\"*\",\"actions\":\"create,update,read,delete\",\"negative\":false}"

# # create user 1
# curl -XPOST \
#     $host/TeamA/admins \
#     -H "Content-Type: application/json"
#     -d "{\"email\":\"userA@example.com\",\"username\":\"userA@example.com\",\"rbac_token_enabled\":true}"

# # create user 2
# curl -XPOST \
#     $host/TeamB/admins \
#     -H "Content-Type: application/json"
#     -d "{\"email\":\"userB@example.com\",\"username\":\"userB@example.com\",\"rbac_token_enabled\":true}" | jq '.id'

# # apply role to user 1
# curl -XPOST \
#     -H "Content-Type: application/json"
#     $host/TeamA/admins/$(curl $host/TeamA/admins $common_args | jq '.data[0].id' | xargs
# )/roles \
#     -d "{\"roles\":\"workspace-super-admin\"}"

# # apply role to user 2
# curl -XPOST \
#     -H "Content-Type: application/json"
#     $host/TeamB/admins/$(curl $host/TeamB/admins -H "Kong-Admin-Token:password" | jq '.data[0].id' | xargs)/roles \
#     -d "{\"roles\":\"workspace-super-admin\"}"

# # register services
# curl -X POST \
#     http://$host/services \
#     -H "Content-Type: application/json"
#     --data name=service1 \
#     --data url='http://mockbin.org'
# curl -X POST \
#     http://$host/services \
#     -H "Content-Type: application/json"
#     --data name=service2 \
#     --data url='http://httpbin.org'

# # register routes
# curl -X POST \
#     http://$host/services/service1/routes \
#     -H "Content-Type: application/json"
#     --data 'paths[]=/routeX' \
#     --data name=routeX
# curl -X POST \
#     http://$host/services/service2/routes \
#     -H "Content-Type: application/json"
#     --data 'paths[]=/routeY' \
#     --data name=routeY

# # register plugins
# curl -X POST \
#     http://$host/routes/routeX/plugins \
#     -H "Content-Type: application/json"
#     --data name=rate-limiting \
#     --data config.minute=5 \
#     --data config.policy=local
# curl -X POST \
#     http://$host/routes/routeY/plugins \
#     -H "Content-Type: application/json"
#     --data name=rate-limiting \
#     --data config.minute=5 \
#     --data config.policy=local
# curl -X POST \
#     http://$host/routes/routeX/plugins \
#     -H "Content-Type: application/json"
#     --data name=proxy-cache \
#     --data "config.strategy=memory"
# curl -X POST \
#     http://$host/routes/routeY/plugins \
#     -H "Content-Type: application/json"
#     --data name=proxy-cache \
#     --data "config.strategy=memory"
