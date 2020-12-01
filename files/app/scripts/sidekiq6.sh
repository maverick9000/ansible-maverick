#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh

export CURRENT_DIR=$DEPLOY_TO/current
cd $DEPLOY_TO/current

if [ -z "${3}" ]
then
  export QUEUES='-q default -q mailers'
else
  export QUEUES="-q ${3}"
fi

export CONCURRENCY=4
/etc/monit/scripts/sidekiq.sh $1 $2
