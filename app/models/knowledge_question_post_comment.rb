# -*- coding: utf-8 -*-
class KnowledgeQuestionPostComment < ActiveRecord::Base
  belongs_to :creator,
             :class_name => "User",
             :foreign_key => :creator_id

  belongs_to :knowledge_question_post

  belongs_to :reply_comment,
             :class_name => "KnowledgeQuestionPostComment",
             :foreign_key => :reply_comment_id

  belongs_to :file_entity

  has_many   :reply_comments,
             :class_name => "KnowledgeQuestionPostComment",
             :foreign_key => :reply_comment_id

  validates :knowledge_question_post_id, :presence => true
  validates :creator_id, :presence => true
  validates_with KnowledgeQuestionPostAndCommentValidator
  default_scope {order(:likes_count => :desc, :created_at => :desc)}

  def is_reply?
    !!self.reply_comment_id
  end

  module UserMethods
    def self.included(base)
      base.has_many :knowledge_question_post_comments, :foreign_key => :creator_id
    end
  end

  include Like::ModelMethods
end
