#!/bin/bash
export APP_NAME={{app.name}}
export APP_ENV={{app.environment}}
export RUBY_VERSION={{app.ruby}}
export DEPLOY_TO=/var/www/{{app.environment}}/{{app.name}}
export RVM={{app.ruby}}@{{app.name}}_{{app.environment}}
export RVM_SOURCE=/usr/local/lib/rvm
export USER={{nginx.user}}
export GROUP={{nginx.group}}
export GEM_PATH=/usr/local/rvm/gems/$RUBY_VERSION:/usr/local/rvm/gems/$RUBY_VERSION@global:/usr/local/rvm/gems/$RVM
export GEM_HOME=/usr/local/rvm/gems/$RVM
export PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/:$GEM_PATH
export HOME=/var/www
export RAILS_ENV=$APP_ENV
export VERBOSE=true

#echo "APP_NAME:"$APP_NAME
#echo "APP_ENV:"$APP_ENV
#echo "DEPLOY_TO:"$DEPLOY_TO
#echo "RVM:"$RVM
#echo "ENV:"
#env

cd $DEPLOY_TO/current
source $RVM_SOURCE
rvm $RVM
umask 0002
