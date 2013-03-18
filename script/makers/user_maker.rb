require 'bundler'
Bundler.require(:examples)

class UserMaker
  AVATAR_DIR = File.join(Rails.root, 'tmp', 'avatars')

  attr_reader :type, :real_names, :progressbar

	def initialize(type, real_names)
		@type        = type
		@real_names  = real_names
    @progressbar = _make_progressbar
	end

	def self.load_yaml(yaml)
		type, real_names = YAML.load_file("./script/data/#{yaml}.yaml")
		self.new(type, real_names)
	end

	def produce
		self.real_names.each_with_index do |real_name, index|
			num = index + 1

      if File.exists?(_avatar_path(real_name))
        File.open(_avatar_path(real_name)) do |avatar|
          User.create(_user_attrs(real_name, num, avatar))
        end
      else
        User.create(_user_attrs(real_name, num))
      end

      self.progressbar.increment
		end
	end

private

  def _avatar_path(name)
    File.join(AVATAR_DIR, self.type.pluralize, "#{name}.png")
  end

  def _make_progressbar
    ProgressBar.create(title:  type.pluralize.capitalize,
                       length: 64,
                       total:  real_names.count,
                       format: '%t: |%b>>%i| %p%%')
  end

	def _name_template(num)
		"#{self.type}#{num}"
	end

	def _user_attrs(real_name, num, avatar=nil)
		{
			login:    "#{_name_template(num)}", 
			name:     real_name, 
			password: 1234, 
			email:    "#{_name_template(num)}@edu.dev",
			role:     self.type,
      avatar:   avatar
		}
	end
end
