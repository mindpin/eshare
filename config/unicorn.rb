# worker 数量
worker_processes 3

MINDPIN_MRS_DATA_PATH = "/MINDPIN_MRS_DATA"
# 日志位置
stderr_path("/#{MINDPIN_MRS_DATA_PATH}/logs/unicorn-eshare-error.log")
stdout_path("/#{MINDPIN_MRS_DATA_PATH}/logs/unicorn-eshare.log")

# 加载 超时设置 监听
preload_app true
timeout 60
listen "/#{MINDPIN_MRS_DATA_PATH}/sockets/unicorn-eshare.sock", :backlog => 2048

pid_file_name = "/#{MINDPIN_MRS_DATA_PATH}/pids/unicorn-eshare.pid"
pid pid_file_name

# REE GC
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = pid_file_name + '.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # ...
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end