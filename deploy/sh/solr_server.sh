#! /bin/sh

current_path=`cd "$(dirname "$0")"; pwd`

. $current_path/function.sh

MINDPIN_MRS_DATA_PATH=`ruby $current_path/parse_property.rb MINDPIN_MRS_DATA_PATH`
rails_env=`ruby $current_path/parse_property.rb RAILS_ENV`

processor_pid=$MINDPIN_MRS_DATA_PATH/pids/solr-server.pid
index_dir=$MINDPIN_MRS_DATA_PATH/solr_index/$rails_env/

port=`ruby $current_path/get_solr_port.rb $rails_env`


echo "######### info #############"
echo "port $port"
echo "solr_index_dir $index_dir"
echo "RAILS_ENV $rails_env"
echo "pid_file $processor_pid"
echo "######### info #############"

case "$1" in
  start)
    assert_process_from_pid_file_not_exist $processor_pid
    solr-server -p $port -d $index_dir -b $processor_pid
    echo "solr-server start ............... $(command_status)"
  ;;
  stop)
    kill -9 `cat $processor_pid`
    echo "solr-server stop ................ $(command_status)"
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