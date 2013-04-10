#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
. $current_path/function.sh
MINDPIN_MRS_DATA_PATH=`ruby $current_path/parse_property.rb MINDPIN_MRS_DATA_PATH`

processor_pid=$MINDPIN_MRS_DATA_PATH/pids/sidekiq.pid
log_file=$MINDPIN_MRS_DATA_PATH/logs/sidekiq.log

case "$1" in
  start)
    assert_process_from_pid_file_not_exist $processor_pid
    echo "sidekiq start"
    cd $current_path/../../
    bundle exec sidekiq 1>> $log_file 2>> $log_file &
    command_status
    echo $! > $processor_pid
  ;;
  stop)
    echo "sidekiq stop"
    kill -9 `cat $processor_pid`
    command_status
  ;;
  restart)
    $0 stop
    sleep 1
    $0 start
  ;;
  *)
    echo "tip:(start|stop|restart)"
    exit 5
  ;;
esac
exit 0
