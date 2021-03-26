#!/bin/bash

# register license
curl -XPOST \
    localhost:7001/licenses \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"payload\": \"$(cat konnect-license.json | sed 's/"/\\"/g')\" }"

# create workspace 1
curl -XPOST \
    localhost:7001/workspaces \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"name\":\"TeamA\",\"meta\":{\"color\":\"#C9604C\"}}"

# create workspace 2
curl -XPOST \
    localhost:7001/workspaces \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"name\":\"TeamB\",\"meta\":{\"color\":\"#C960FF\"}}"

# create role for workspace 1
curl -XPOST \
    localhost:7001/TeamA/rbac/roles \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"name\":\"workspace-super-admin\"}"
curl -XPOST \
    localhost:7001/TeamA/rbac/roles/$(curl localhost:7001/TeamA/rbac/roles -H "Kong-Admin-Token:password" | jq '.data[0].id' | xargs)/endpoints \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"endpoint\":\"*\",\"actions\":\"create,update,read,delete\",\"negative\":false}"

# create role for workspace 2
curl -XPOST \
    localhost:7001/TeamB/rbac/roles \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"name\":\"workspace-super-admin\"}"
curl -XPOST \
    localhost:7001/TeamB/rbac/roles/$(curl localhost:7001/TeamB/rbac/roles -H "Kong-Admin-Token:password" | jq '.data[0].id' | xargs)/endpoints \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"endpoint\":\"*\",\"actions\":\"create,update,read,delete\",\"negative\":false}"

# create user 1
curl -XPOST \
    localhost:7001/TeamA/admins \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"email\":\"userA@example.com\",\"username\":\"userA@example.com\",\"rbac_token_enabled\":true}"

# create user 2
curl -XPOST \
    localhost:7001/TeamB/admins \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token:password" \
    -d "{\"email\":\"userB@example.com\",\"username\":\"userB@example.com\",\"rbac_token_enabled\":true}" | jq '.id'

# apply role to user 1
curl -XPOST \
    -H "Kong-Admin-Token:password" \
    -H "Content-Type: application/json" \
    localhost:7001/TeamA/admins/$(curl localhost:7001/TeamA/admins -H "Kong-Admin-Token:password" | jq '.data[0].id' | xargs
)/roles \
    -d "{\"roles\":\"workspace-super-admin\"}"

# apply role to user 2
curl -XPOST \
    -H "Kong-Admin-Token:password" \
    -H "Content-Type: application/json" \
    localhost:7001/TeamB/admins/$(curl localhost:7001/TeamB/admins -H "Kong-Admin-Token:password" | jq '.data[0].id' | xargs)/roles \
    -d "{\"roles\":\"workspace-super-admin\"}"

# register services
curl -X POST \
    http://localhost:7001/services \
    -H "Kong-Admin-Token:password" \
    --data name=service1 \
    --data url='http://mockbin.org'
curl -X POST \
    http://localhost:7001/services \
    -H "Kong-Admin-Token:password" \
    --data name=service2 \
    --data url='http://httpbin.org'

# register routes
curl -X POST \
    http://localhost:7001/services/service1/routes \
    -H "Kong-Admin-Token:password" \
    --data 'paths[]=/routeX' \
    --data name=routeX
curl -X POST \
    http://localhost:7001/services/service2/routes \
    -H "Kong-Admin-Token:password" \
    --data 'paths[]=/routeY' \
    --data name=routeY

# register plugins
curl -X POST \
    http://localhost:7001/routes/routeX/plugins \
    -H "Kong-Admin-Token:password" \
    --data name=rate-limiting \
    --data config.minute=5 \
    --data config.policy=local
curl -X POST \
    http://localhost:7001/routes/routeY/plugins \
    -H "Kong-Admin-Token:password" \
    --data name=rate-limiting \
    --data config.minute=5 \
    --data config.policy=local
curl -X POST \
    http://localhost:7001/routes/routeX/plugins \
    -H "Kong-Admin-Token:password" \
    --data name=proxy-cache \
    --data "config.strategy=memory"
curl -X POST \
    http://localhost:7001/routes/routeY/plugins \
    -H "Kong-Admin-Token:password" \
    --data name=proxy-cache \
    --data "config.strategy=memory"
