#!/bin/sh
/opt/mongodb/bin/mongod --master --bind_ip "0.0.0.0" &
ruby script/server
