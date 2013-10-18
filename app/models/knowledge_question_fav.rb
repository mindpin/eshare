class KnowledgeQuestionFav < ActiveRecord::Base
  attr_accessible :user, :knowledge_question

  belongs_to :user
  belongs_to :knowledge_question

  validates :user, :knowledge_question, :presence => true
  validates :knowledge_question_id,
    :uniqueness => {:scope => :user_id}

  scope :by_user, lambda{|user| {:conditions => "knowledge_question_favs.user_id = #{user.id}"}}

  module UserMethods
    def self.included(base)
      base.has_many :knowledge_question_favs
      base.has_many :fav_knowledge_questions,
        :through => :knowledge_question_favs,
        :source => :knowledge_question,
        :order => "knowledge_question_favs.created_at desc"
    end
  end

  module KnowledgeQuestionMethods
    def self.included(base)
      base.has_many :knowledge_question_favs
    end

    def fav_by_user(user)
      fav = self.knowledge_question_favs.by_user(user).first
      return true if fav.present?
      self.knowledge_question_favs.create(:user => user)
      return true
    end

    def cancel_fav_by_user(user)
      self.knowledge_question_favs.by_user(user).destroy_all
    end
  end
end
