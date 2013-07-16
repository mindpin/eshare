#! /bin/sh

current_path=`cd "$(dirname "$0")"; pwd`

. $current_path/function.sh

MINDPIN_MRS_DATA_PATH=`ruby $current_path/parse_property.rb MINDPIN_MRS_DATA_PATH`

processor_pid=$MINDPIN_MRS_DATA_PATH/pids/java_step_tester_server.pid

port=`ruby $current_path/get_java_step_tester_port.rb`

echo "######### info #############"
echo "port $port"
echo "pid_file $processor_pid"
echo "######### info #############"

case "$1" in
  start)
    assert_process_from_pid_file_not_exist $processor_pid
    java_step_tester -p $port -b $processor_pid
    echo "java_step_tester start ............... $(command_status)"
  ;;
  status)
    check_run_status_from_pid_file $processor_pid 'java_step_tester'
  ;;
  stop)
    kill -9 `cat $processor_pid`
    echo "java_step_tester stop ................ $(command_status)"
  ;;
  restart)
    $0 stop
    sleep 1
    $0 start
  ;;
  *)
    echo "tip:(start|stop|restart|status)"
    exit 5
  ;;
esac
exit 0