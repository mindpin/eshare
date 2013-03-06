#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
eshare_project_path=$current_path/../..
. $current_path/function.sh

MINDPIN_MRS_DATA_PATH="/MINDPIN_MRS_DATA"
rails_env="development"

pid=$MINDPIN_MRS_DATA_PATH/pids/unicorn-eshare.pid

cd $eshare_project_path
echo $rails_env
echo `pwd`

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


