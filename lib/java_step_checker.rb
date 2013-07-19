class JavaStepChecker
  def initialize(rule, input)
    @rule = rule
    @input = input
  end

  def check
    client = TCPSocket.new R::JAVA_STEP_TESTER_HOST, R::JAVA_STEP_TESTER_PORT

    request = { :input => @input , :rule => @rule }
    client.send(request.to_json + "\n", 0)
    client.flush

    response = client.gets
    client.close

    JSON.parse(response)
  rescue Errno::EPIPE => e
    return {'error' => '服务器忙，请稍后再试', 'success' => false}
  end
end