# -*- coding: utf-8 -*-
class KnowledgeQuestion < ActiveRecord::Base
  KINDS = {
    :single_choice    => "单选题",
    :multiple_choices => "多选题",
    :true_false       => "判断题",
    :code             => "编程题"
  }

  attr_accessible :title,
                  :kind,
                  :answer,
                  :knowledge_node_id,
                  :as => :true_false

  attr_accessible :title,
                  :kind,
                  :answer,
                  :choices,
                  :knowledge_node_id,
                  :as => [:single_choice, :multiple_choices]

  attr_accessible :title,
                  :kind,
                  :desc,
                  :rule,
                  :init_code,
                  :code_type,
                  :knowledge_node_id,
                  :as => :code

  validates :title,
            :kind,
            :knowledge_node_id,
            :presence => true

  validates :choices,
            :answer,
            :presence => {:if => :is_choice?}

  validates :answer,
            :presence => {:if => :is_true_false?}

  validates :desc,
            :rule,
            :init_code,
            :code_type,
            :presence => {:if => :is_code?}



  def kind(zh: false)
    raw = (read_attribute(:kind) || "").to_sym
    return KINDS[raw] if zh
    raw
  end

  def choices=(input)
    array = input.is_a?(String) ? input.split("\n").map(&:strip) : input
    write_attribute :choices, array.to_json
  end

  def choices
    JSON.parse(read_attribute(:choices) || "[]")
  end

  def choices_str
    self.choices.join("\n")
  end

  def self.make(kind, attrs = {})
    self.factory(:create, kind, attrs)
  end

  def self.touch(kind, attrs = {})
    self.factory(:new, kind, attrs)
  end

  def self.factory(action, kind, attrs)
    self.send action, attrs.merge(:kind => kind), :as => kind.to_sym
  end

  private

  def is_choice?
    [:single_choice, :multiple_choices].include? self.kind
  end

  def is_true_false?
    self.kind == :true_false
  end

  def is_code?
    self.kind == :code
  end


  include KnowledgeAnswerRecord::KnowledgeQuestionMethods
end
