class JavaStepChecker
  def initialize(java_step, input, user)
    @java_step = java_step
    @input = input
    @user = user
  end

  def check
    client = TCPSocket.new R::JAVA_STEP_TESTER_HOST, R::JAVA_STEP_TESTER_PORT

    request = { :input => @input , :rule => @java_step.rule }
    client.send(request.to_json + "\n", 0)
    client.flush

    response = client.gets
    client.send('bye' + "\n", 0)
    client.flush
    client.close

    response
  end
end