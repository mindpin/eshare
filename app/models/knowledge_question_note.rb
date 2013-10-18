# -*- coding: utf-8 -*-
class KnowledgeQuestionNote < ActiveRecord::Base
  attr_accessible :knowledge_question, :creator, :content, :file_entity, :code, :code_type

  belongs_to :knowledge_question
  belongs_to :file_entity
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  validates :knowledge_question, :creator, :code_type,
            :presence => true

  validate :validate_note_type
  def validate_note_type    
    errors.add(:base, '至少有一项不能为空') if content.blank? && file_entity.blank? && code.blank?
  end


  scope :by_creator, lambda{|creator| {:conditions => ['creator_id = ?', creator.id]} }


  scope :by_knowledge_net, lambda {|knowledge_net|
    joins(%`
      INNER JOIN
        knowledge_questions
      ON
        knowledge_questions.id = knowledge_question_notes.knowledge_question_id
      INNER JOIN
        knowledge_node_records 
      ON
        knowledge_node_records.knowledge_net_id = "#{knowledge_net.id}"
    `).where(%`
        knowledge_node_records.knowledge_node_id = knowledge_questions.knowledge_node_id
    `)
  }



  module KnowledgeQuestionMethods
    def self.included(base)
      base.has_many :knowledge_question_notes
    end
  end


  module UserMethods
    def self.included(base)
      base.has_many :knowledge_question_notes, :foreign_key => 'creator_id'
    end
  end

end