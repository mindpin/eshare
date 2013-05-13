class TermOutputReporter
  attr_reader :cmd

  COLORS = {
    '30' => 'black',
    '31' => 'red',
    '32' => 'green',
    '33' => 'yellow',
    '34' => 'blue',
    '35' => 'magenta',
    '36' => 'cyan',
    '37' => 'white',
    '90' => 'grey',
    'other' => 'white'
  }

  def initialize(cmd)
    @cmd = cmd
  end

  def job_id
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S%L")
    @job_id ||= Base64.encode64("#{timestamp}#{cmd}").chomp
  end

  def run
    IO.popen(cmd) do |io|
      io.each do |line|
        FayeClient.publish "/cmd/#{job_id}", {:output => ansi_to_html(line)}
      end
    end
  end

  def ansi_to_html(ansi_seq)
    tokenize(ansi_seq).map do |k, v|
      color = COLORS[k] ? COLORS[k] : COLORS['other']
      "<span style='color:#{color};'>#{v}</span>"
    end.join("") + "<br />"
  end

  def tokenize(ansi_seq)
    tokens = ansi_seq.chomp.split(/\e\[([\w;]*)m/)
    tokens.count == 1 ? Hash["other", *tokens] : Hash[*tokens[1..-1]]
  end
end
