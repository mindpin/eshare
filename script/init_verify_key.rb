require File.expand_path('../../lib/project_verify', __FILE__)
require File.expand_path('../../config/initializers/mindpin_global_methods', __FILE__)
verify = ProjectVerify.new

key_path = File.expand_path('../../public/project.key', __FILE__)
if File.exists?(key_path)
  key = File.open(key_path).read
  key = randstr(16) if key.strip == ""
else
  key = randstr(16)
  File.open(key_path,'w') {|f|f << key}
end
mac = verify.get_mac
p "################"
p "key #{key}"
p "mac #{mac}"
p "################"