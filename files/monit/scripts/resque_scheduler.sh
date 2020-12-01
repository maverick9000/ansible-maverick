#!/bin/bash
echo "APP:"$APP
echo "APP_ENV:"$APP_ENV
echo "DEPLOY_TO:"$DEPLOY_TO
echo "RVM:"$RVM

PATH=/usr/local/rvm/gems/$RVM/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/rvm/gems/$RVM/bin/bundle
DAEMON_OPTS="exec rake resque:scheduler &> $DEPLOY_TO/shared/log/resque_scheduler.log"
NAME=resque_scheduler
DESC="$APP $APP_ENV resque scheduler"
PID_DIR=$DEPLOY_TO/shared/pids
CURRENT_DIR=$DEPLOY_TO/current

export VERBOSE=1
export PATH=$PATH
export HOME=$DEPLOY_TO

cd $CURRENT_DIR
source /usr/local/lib/rvm
rvm $RVM

case "$1" in
  start)
  echo -n "Starting $DESC: "
	start-stop-daemon --start --pidfile $PID_DIR/$NAME.pid --background --make-pidfile --chdir $CURRENT_DIR \
	    --exec $DAEMON -- $DAEMON_OPTS
	echo "$NAME."
	;;
  stop)
  echo -n "Stopping $DESC: "
  kill `cat $PID_DIR/$NAME.pid`
  rm $PID_DIR/$NAME.pid
  echo "$NAME."
  ;;
  restart|force-reload)
  echo -n "Restarting $DESC: "
  kill `cat $PID_DIR/$NAME.pid`
  rm $PID_DIR/$NAME.pid
  sleep 1
	start-stop-daemon --start --quiet --pidfile \
	    $PID_DIR/$NAME.pid --background --make-pidfile --chdir $CURRENT_DIR --exec $DAEMON -- $DAEMON_OPTS || true
	echo "$NAME."
	;;
  reload)
        echo -n "Reloading $DESC configuration: "
        test_nginx_config
        start-stop-daemon --stop --signal HUP --quiet --pidfile $PID_DIR/$NAME.pid \
            --exec $DAEMON || true
        echo "$NAME."
        ;;
  *)
  echo "Usage: $NAME {start|stop|restart|force-reload}" >&2
  exit 1
  ;;
esac

exit 0
