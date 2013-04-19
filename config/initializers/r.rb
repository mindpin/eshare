class R
  HASH = YAML.load_file(Rails.root.join('config/r.yaml'))
  LIBREOFFICE_PATH = HASH['libreoffice_path']
  CONVERT_BASE_PATH = File.expand_path(HASH['convert_base_path'], Rails.root.join('config'))
  UPLOAD_BASE_PATH = File.join(CONVERT_BASE_PATH, "static_files")
end
