class CourseFav < ActiveRecord::Base
  simple_taggable

  attr_accessible :course, :user, :comment_content

  belongs_to :user
  belongs_to :course

  validates :user,   :presence => true
  validates :course, :presence => true

  scope :by_user, lambda{|user| {:conditions => ['user_id = ?', user.id]} }

  def creator
   user
  end

  module UserMethods
    def self.included(base)
      base.has_many :course_favs
    end

  end

  module CourseMethods
    def self.included(base)
      base.has_many :course_favs
    end

    # 增加或修改收藏
    # options {:comment_content => '', :tags => ''}
    def set_fav(user, options)
      return if user.blank?
      course_fav = self.course_favs.by_user(user).first
      if course_fav.blank?
        course_fav = self.course_favs.create(:user => user, :comment_content => options[:comment_content])
      else
        course_fav.update_attributes(:comment_content => options[:comment_content])
      end
      course_fav.set_tag_list(options[:tags]||"",:user => user)
    end
  end
end