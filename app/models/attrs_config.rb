class AttrsConfig < ActiveRecord::Base
  attr_accessible :role, :field, :field_type

  validates :role, :field, :field_type, :presence => true
  validates :field,      :uniqueness => {:scope => [:role]}
  validates :role,       :inclusion  => %w(student teacher)
  validates :field_type, :inclusion  => %w(string boolean integer datetime)

  def role=(role)
    write_attribute(:role, role.to_s)
  end

  def field_type=(type)
    write_attribute(:field_type, type.to_s)
  end

  def self.types
    {:string => '字符串', :boolean => '布尔值', :integer => '整数', :datetime => '日期'}
  end

  def self.get(role)
    self.where(:role => role).inject({}) do |hash, config|
      hash[config.field.to_sym] = config.field_type.to_sym
      hash
    end
  end
end
