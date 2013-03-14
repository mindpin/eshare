module AttrsConfigs
  def self.get(config_name)
    YAML.load_file('lib/dynamic_attrs/student_attrs.yaml').symbolize_keys
  end
end