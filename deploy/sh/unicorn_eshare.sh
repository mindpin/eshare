#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
eshare_project_path=$current_path/../..
. $current_path/function.sh

MINDPIN_MRS_DATA_PATH=`ruby $current_path/parse_property.rb MINDPIN_MRS_DATA_PATH`
rails_env=`ruby $current_path/parse_property.rb RAILS_ENV`
pid=$MINDPIN_MRS_DATA_PATH/pids/unicorn-eshare.pid

cd $eshare_project_path
echo "######### info #############"
echo "RAILS_ENV $rails_env"
echo "pid_file_path $pid"
echo "eshare_project_path $(pwd)"
echo "############################"

case "$1" in
  start)
    assert_process_from_pid_file_not_exist $pid
    echo "start"
    unicorn_rails -c config/unicorn.rb -E $rails_env -D
    command_status  
  ;;
  stop)
    echo "stop"
    kill `cat $pid`
    command_status  
  ;;
  usr2_stop)
    echo "usr2_stop"
    kill -USR2 `cat $pid`
    command_status
  ;;
  restart)
    echo "restart"
    cd $sh_dir
    $1 stop
    sleep 1
    $1 start
  ;;
  *)
    echo "tip:(start|stop|restart|usr2_stop)"
    exit 5
  ;;
esac

exit 0


