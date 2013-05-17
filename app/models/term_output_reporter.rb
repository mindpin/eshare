class TermOutputReporter
  attr_reader :cmd

  COLORS = {
    "30" => "black",
    "31" => "red",
    "32" => "green",
    "33" => "yellow",
    "34" => "blue",
    "35" => "magenta",
    "36" => "cyan",
    "37" => "white",
    "90" => "grey",
  }

  def initialize(cmd)
    @cmd = cmd
  end

  def job_id
    @job_id ||= Time.now.utc.strftime("%Y%m%d%H%M%S%L")
  end

  def run
    IO.popen(cmd) do |io|
      io.each do |line|
        FayeClient.publish_queue "/cmd", {
          :output => ansi_to_html(line), 
          :job_id => job_id
        }
      end
    end
  end

  def ansi_to_html(ansi_seq)
    tokenize(ansi_seq).map do |k, v|
      color = COLORS[k] ? COLORS[k] : "white"
      "<span style='color:#{color};'>#{v}</span>"
    end.join("") + "<br />"
  end

  def tokenize(ansi_seq)
    tokens = ansi_seq.chomp.split(/(\e\[[\w;]*m)/)
    tokens.shift if tokens.first.empty?
    tokens.pop if tokens.last.match(/\e\[[\w;]*m/)
    tokens.prepend "37" if !tokens.first.match(/\e\[[\w;]*m/)
    tokens.map! {|token| token.gsub(/\e\[([\d;]*)m/, "\\1")}
    Hash[*tokens]
  end
end
