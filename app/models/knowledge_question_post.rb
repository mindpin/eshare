class KnowledgeQuestionPost < ActiveRecord::Base
  belongs_to :creator,
             :class_name => "User",
             :foreign_key => :creator_id

  belongs_to :knowledge_question

  has_many   :main_comments,
             :class_name => "KnowledgeQuestionPostComment",
             :foreign_key => :knowledge_question_post_id

  validates :knowledge_question_id, :presence => true
  validates :creator_id, :presence => true
  validates_with KnowledgeQuestionPostAndCommentValidator
  default_scope {order(:likes_count => :desc, :created_at => :desc)}

  module UserMethods
    def self.included(base)
      base.has_many :knowledge_question_posts, :foreign_key => :creator_id
    end
  end

  module KnowledgeQuestionMethods
    def self.included(base)
      base.has_many :posts,
                    :class_name => "KnowledgeQuestionPost",
                    :foreign_key => :knowledge_question_id
    end
  end

  include Like::ModelMethods
end
