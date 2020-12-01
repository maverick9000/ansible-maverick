#! /bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh

PID_FILE=$DEPLOY_TO/shared/pids/puma.pid
STATE_FILE=$DEPLOY_TO/shared/pids/puma.state
CONTROL_SOCKET="unix://$DEPLOY_TO/shared/sockets/pumactl.socket"
SOCKET="unix://$DEPLOY_TO/shared/sockets/puma.socket"

case "$1" in
  start)
    echo "Starting puma"
    bundle exec puma -e $RAILS_ENV -d -b $SOCKET -S $STATE_FILE --control $CONTROL_SOCKET --pidfile $PID_FILE --redirect-stderr $DEPLOY_TO/shared/log/puma_err.log
    echo "Done!"
    ;;
  stop)
    echo "Stopping puma"
    bundle exec pumactl -S $STATE_FILE stop
    echo "Done"
    ;;
  *)
    echo "Usage: puma {start|stop} {server_index}"
    exit 1
    ;;
esac

exit 0
