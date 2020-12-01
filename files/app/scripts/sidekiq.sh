#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh

INDEX="$2"
PID_FILE=$DEPLOY_TO/shared/pids/sidekiq.$INDEX.pid
LOG_FILE=$DEPLOY_TO/shared/log/sidekiq.$INDEX.log

case "$1" in
  start)
    echo "Starting sidekiq $INDEX.."
    bundle exec sidekiq -C $DEPLOY_TO/shared/config/sidekiq.yml --index $INDEX --pidfile $PID_FILE --environment $RAILS_ENV --logfile $LOG_FILE --daemon
    echo "Done!"
    ;;
  stop)
    echo "Stopping sidekiq $INDEX.."
    bundle exec sidekiqctl stop $PID_FILE
    echo "Done"
    ;;
  *)
    echo "Usage: sidekiq {start|stop} {server_index}"
    exit 1
    ;;
esac

exit 0
