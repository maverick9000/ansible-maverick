#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh

export QUEUES=*
/etc/monit/scripts/resque_worker.sh $1 $2
