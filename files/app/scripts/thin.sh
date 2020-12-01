#! /bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh

INDEX="$2"
PID_FILE=$DEPLOY_TO/shared/pids/thin.$INDEX.pid
SOCKET=$DEPLOY_TO/shared/sockets/thin.$INDEX.socket

case "$1" in
  start)
    echo "Starting thin $INDEX.."
    bundle exec thin start -d -e $APP_ENV -P $PID_FILE -c $DEPLOY_TO/current --user $USER --group $GROUP -S $SOCKET
    echo "Done!"
    ;;
  stop)
    echo "Stopping thin $INDEX.."
    bundle exec thin stop -P $PID_FILE
    echo "Done"
    ;;
  *)
    echo "Usage: thin {start|stop} {server_index}"
    exit 1
    ;;
esac

exit 0
