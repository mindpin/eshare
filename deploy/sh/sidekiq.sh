#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
. $current_path/function.sh
MINDPIN_MRS_DATA_PATH=`ruby $current_path/parse_property.rb MINDPIN_MRS_DATA_PATH`
rails_env=`ruby $current_path/parse_property.rb RAILS_ENV`

processor_pid=$MINDPIN_MRS_DATA_PATH/pids/sidekiq.pid
log_file=$MINDPIN_MRS_DATA_PATH/logs/sidekiq.log

echo "######### info #############"
echo "RAILS_ENV $rails_env"
echo "############################"

case "$1" in
  start)
    assert_process_from_pid_file_not_exist $processor_pid
    cd $current_path/../../
    nohup bundle exec sidekiq -q course_ware -e $rails_env 1>> $log_file 2>> $log_file &
    echo $! > $processor_pid
    echo "sidekiq start ............... $(command_status)"
  ;;
  status)
    check_run_status_from_pid_file $processor_pid 'sidekiq'
  ;;
  stop)
    kill -9 `cat $processor_pid`
    echo "sidekiq stop ................ $(command_status)"
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
