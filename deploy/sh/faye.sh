#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
. $current_path/function.sh

processor_pid=$current_path/../../tmp/pids/thin.8080.pid

cd $current_path/../../

case "$1" in
  start)
    assert_process_from_pid_file_not_exist $processor_pid
    bundle exec thin start -f -C config/thin.yml -R faye.ru
    echo "faye start ............... $(command_status)"
  ;;
  status)
    check_run_status_from_pid_file $processor_pid 'faye'
  ;;
  stop)
    bundle exec thin stop -f -C config/thin.yml -R faye.ru
    echo "faye stop ................ $(command_status)"
  ;;
  restart)
    $0 stop
    sleep 1
    $0 start
  ;;
  *)
    echo "tip:(start|stop|restart|status|status)"
    exit 5
  ;;
esac
exit 0