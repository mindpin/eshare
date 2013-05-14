require './script/makers/base_maker.rb'

class UserMaker < BaseMaker
  AVATAR_DIR = File.join(Rails.root, 'tmp', 'avatars')

	set_producer {|real_name, index|
    num = index + 1

    if File.exists?(_avatar_path(real_name))
      File.open(_avatar_path(real_name)) do |avatar|
        User.create(_user_attrs(real_name, num, avatar))
      end
    else
      User.create(_user_attrs(real_name, num))
    end
  }

  def _avatar_path(name)
    File.join(AVATAR_DIR, self.type.pluralize, "#{name}.png")
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
