require "yaml"

config = YAML.load_file(File.expand_path("../../../config/sunspot.yml",__FILE__))
rails_env = ARGV[0]

value = config[rails_env]['solr']['port']

puts value