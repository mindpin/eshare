# -*- coding: utf-8 -*-
class KnowledgeAnswerRecord < ActiveRecord::Base
  attr_accessible :knowledge_question, :user, :correct_count, :error_count

  belongs_to :knowledge_question
  belongs_to :user

  validates :knowledge_question, :user,
            :presence => true


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
      self.knowledge_answer_records.where(:user_id => user.id).first
    end

  end


  module UserMethods
    def self.included(base)
      base.has_many :knowledge_answer_records
    end
  end

end