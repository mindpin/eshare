require 'bundler'
Bundler.require(:examples)

class UserMaker
  attr_reader :type, :real_names, :progressbar

	def initialize(type, real_names)
		@type        = type.to_sym
		@real_names  = real_names
    @progressbar = ProgressBar.create title: type.pluralize.capitalize, length: 64, total: real_names.count, format: '%t: |%b>>%i| %p%%'
	end

	def self.load_yaml(yaml)
		type, real_names = YAML.load_file("./script/data/#{yaml}.yaml")
		self.new(type, real_names)
	end

	def produce
		self.real_names.each_with_index do |real_name, index|
			num = index + 1
			user = User.create(user_attrs(real_name, num))
      user.set_role self.type
      user.save
      self.progressbar.increment
		end
	end

private

	def name_template(num)
		"#{self.type}#{num}"
	end

	def user_attrs(real_name, num)
		{login: "#{name_template(num)}", name: real_name, password: 1234, email: "#{name_template(num)}@edu.dev"}
	end

	def have_attached_role?
		[:student, :teacher].include? self.type
	end
end
