class R
  HASH = YAML.load_file(Rails.root.join('config/r.yaml'))
  LIBREOFFICE_PATH = HASH['libreoffice_path']
  CONVERT_BASE_PATH = File.expand_path(HASH['convert_base_path'], Rails.root.join('config'))

  STATIC_FILES_DIR = "static_files"
  UPLOAD_BASE_PATH = File.join(CONVERT_BASE_PATH, STATIC_FILES_DIR)
end
