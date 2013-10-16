# -*- coding: utf-8 -*-
class KnowledgeAnswerRecord < ActiveRecord::Base
  attr_accessible :knowledge_question, :user, :correct_count, :error_count

  belongs_to :knowledge_question
  belongs_to :user

  validates :knowledge_question, :user, :correct_count, :error_count,
            :presence => true

  scope :by_knowledge_net, lambda {|knowledge_net|
    joins(%`
      INNER JOIN
        knowledge_questions
      ON
        knowledge_questions.id = knowledge_answer_records.knowledge_question_id
      INNER JOIN
        knowledge_node_records 
      ON
        knowledge_node_records.knowledge_node_id = knowledge_questions.knowledge_node_id
    `).where(%`
      knowledge_node_records.knowledge_net_id = "#{knowledge_net.id}"
    `)
  }


  module KnowledgeQuestionMethods
    def self.included(base)
      base.has_many :knowledge_answer_records
    end

    def correct_count_of_user(user)
      _answer_record_of(user).correct_count
    end

    def error_count_of_user(user)
      _answer_record_of(user).error_count
    end

    def increase_correct_count_of_user(user)
      answer_record = _answer_record_of(user)
      answer_record.correct_count = answer_record.correct_count + 1
      answer_record.save
    end

    def increase_error_count_of_user(user)
      answer_record = _answer_record_of(user)
      answer_record.error_count = answer_record.error_count + 1
      answer_record.save
    end

    private
    def _answer_record_of(user)
      if self.knowledge_answer_records.blank?
        return self.knowledge_answer_records.build(
          :user => user, 
          :correct_count => 0, 
          :error_count => 0)
      end
      self.knowledge_answer_records.where(:user_id => user.id).first
    end

  end


  module UserMethods
    def self.included(base)
      base.has_many :knowledge_answer_records
    end
  end

end