STDOUT.sync = true
yaml = Rails.root.join('script/data/video_courses.yaml')
if !File.exists?(yaml)
  `wget https://gist.github.com/kaid/589f60e53dbb735878e8/raw/0d2b5fcd025c5d412759c05d35f1afa7b9d21fe1/video_courses.yaml -O #{yaml} --no-check-certificate`
end
Course.import_from_yaml