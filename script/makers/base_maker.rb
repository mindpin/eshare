require 'bundler'
Bundler.require(:examples)

class BaseMaker
  attr_reader :type, :data, :progressbar

  def initialize(yaml=nil)
    load_yaml(yaml)
    @progressbar = _make_progressbar
  end

  def load_yaml(yaml=nil)
    yaml_name = yaml ? yaml : model_name
    @type,  @data = YAML.load_file("./script/data/#{yaml_name}.yaml")
  end

  def model_name
    self.class.to_s.underscore.gsub(/_maker/, "").pluralize
  end

  def self.set_producer(&block)
    define_method :producer do
      block
    end
  end

  def produce
    self.data.each_with_index do |item, index|
      self.producer.bind(self).call(item, index)
      self.progressbar.increment
    end
  end

private

  def _make_progressbar
    ProgressBar.create(title:  type.pluralize.capitalize,
                       length: 64,
                       total:  data.count,
                       format: '%t: |%b>>%i| %p%%')
  end
end
