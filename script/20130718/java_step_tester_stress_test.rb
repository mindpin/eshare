require 'socket'
require 'active_support/json/encoding'

def get_input(index)
  return %`
    public int sum_#{index}(int a, int b){
      return a + b;
    }
  `
end

def get_rule(index)
  return %`
    @Test
    public void test_1() {
      RuleTest a = new RuleTest();
      Assert.assertEquals(3,a.sum_#{index}(1, 2));
    }

    @Test
    @TestDescription("sum_n(3, 4) -> 7")
    public void test_2() {
      RuleTest a = new RuleTest();
      Assert.assertEquals(7,a.sum_#{index}(3, 4));
    }
  `
end

def get_result(index)
  return {
    "error"   => "",
    "success" => true,
    "assets"  => [
      {
        "test_description" => "test_1",
        "result"           => true,
        "exception"        => ""
        
      },
      {
        "test_description" => "sum_n(3, 4) -> 7",
        "result"           => true,
        "exception"        => ""
      }
    ]
  }
end

def send_request(input , rule)
  client = TCPSocket.new '192.168.1.26', 10001

  request = { :input => input , :rule => rule }
  client.send(request.to_json + "\n", 0)
  client.flush

  response = client.gets
  client.close

  return JSON.parse(response)
rescue
  return {'error' => '服务器忙，请稍后再试', 'success' => false}
end

def stress_test
  threads = []
  0.upto(50) do |i|

    threads << Thread.new{
      input  = get_input(i)
      rule   = get_rule(i)
      result = get_result(i)
      hash = send_request(input , rule)

      if hash != result
        p hash
        p "#{i} 错误"
      end
    }

  end

  threads.each{|thx|thx.join}
end



0.upto(10) do
  stress_test
  sleep 1
  p "sleep 1"
end