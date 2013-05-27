class ProjectVerify
  VERIFY_SERVER = 'http://211.101.1.178'

  def check
    code = _get_key_and_mac
    url = File.join(VERIFY_SERVER, "/check/#{code}")
    if Net::HTTP.get_response(URI(url)).code != '200'
      raise 'verify error'
    end
  end

  def get_mac
    re = %r/(?:[^:\-]|\A)(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F](?:[^:\-]|\Z)/io

    output = `ifconfig`
    candidates = output.split(/\n/).select{|line| line =~ re}
    candidates.map{|c| c[re].strip}.first
  end

  private
    def ___(key, mac)
      Digest::MD5.hexdigest("#{key}+#{mac}")
    end

    def ___path
      Rails.root.join('public/project_key/project.key')
    end

    def _get_key_and_mac
      key_path = ___path
      raise 'verify error' if !File.exists?(key_path)
      key = File.open(___path).read
      mac = get_mac
      ___(key, mac)
    end

end
