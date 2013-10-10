# -*- coding: utf-8 -*-
class KnowledgeQuestionPostAndCommentValidator < ActiveModel::Validator
  def validate(model)
    if !(model.content || model.file_entity_id || model.code)
      model.errors.add(:base, "内容、图片和代码须至少有一栏不为空。")
    end

    if model.code.present? && model.code_type.blank?
      model.errors.add(:base, "请指定代码类型。")
    end
  end
end
