class SimpleProgress
  attr_reader :total, :progress

  def initialize(total)
    @total = total
    @progress = 0
  end

  def self.create(total)
    self.new(total).print_percent
  end

  def increment
    @progress += 1
    self.print_percent
  end

  def print_percent
    percent = "#{((progress.to_f / total) * 100).round}%\n"
    print "导入完成 #{percent}"
    self
  end
end