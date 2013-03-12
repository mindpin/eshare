class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :recoverable
  devise :database_authenticatable, :registerable, 
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates :login, :format => {:with => /\A\w+\z/, :message => '只允许数字、字母和下划线'},
                    :length => {:in => 3..20},
                    :presence => true,
                    :uniqueness => {:case_sensitive => false}

  validates :email, :uniqueness => {:case_sensitive => false}

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.where(:login => login).first || self.where(:email => login).first
  end

  # ------------ 以上是用户登录相关代码，不要改动
  # ------------ 任何代码请在下方添加

  # 声明角色
  roles_field :roles_mask, :roles => [:admin, :manager, :teacher, :student]

  attr_accessible :name, :avatar



  has_dynamic_attrs :student_attrs,
                    :fields => {
                      :sid => :integer,
                      :department => :string,
                      :gender => :string,
                      :nation => :string,
                      :tel => :string,
                      :description => :string,
                      :id_card_number => :string,
                      :enroll_date => :datetime,
                      :graduation_date => :datetime
                    }

  has_dynamic_attrs :teacher_attrs,
                    :fields => {
                      :tid => :integer,
                      :department => :string,
                      :gender => :string,
                      :nation => :string,
                      :tel => :string,
                      :description => :string,
                      :id_card_number => :string
                    }


  def self.import(file, role)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      p row
      user = find_by_email(row["email"]) || new
      user.attributes = row.to_hash.slice(*accessible_attributes)
      user.set_role(role)
      user.save
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end


  # admin 模块
  include Student::UserMethods
  include Teacher::UserMethods
  include DynamicAttr::Owner

end
