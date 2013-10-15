# -*- coding: utf-8 -*-
class KnowledgeAnswerRecord < ActiveRecord::Base
  attr_accessible :knowledge_question, :user, :correct_count, :error_count

  belongs_to :knowledge_question
  belongs_to :user

  validates :knowledge_question, :user,
            :presence => true

end