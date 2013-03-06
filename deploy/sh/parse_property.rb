require "yaml"

config = YAML.load_file(File.expand_path("../property.yaml",__FILE__))
key = ARGV[0]
value = config[key]
value = value.gsub(/\/$/,"")
if "MINDPIN_MRS_DATA_PATH" == key
  `mkdir -p #{value}/logs`
  `mkdir -p #{value}/sockets`
  `mkdir -p #{value}/pids`
end

print value