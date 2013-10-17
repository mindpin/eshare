require "spec_helper"

describe KnowledgeQuestionPostAndCommentValidator do
  class DummyComment
    include ActiveModel::Validations

    attr_accessor :content, :image, :code, :code_type
    validates_with KnowledgeQuestionPostAndCommentValidator

    def initialize(content, image, code, code_type)
      self.content = content
      self.image   = image
      self.code    = code
      self.code_type = code_type
    end
  end

  subject {DummyComment.new(nil, nil, "asasd", "blascript")}

  it {should be_valid}

  context "when invalid" do
    context "when content invalid" do
      subject {DummyComment.new(nil, nil, nil, nil)}

      it {should be_invalid}
    end

    context "when code_type invalid" do
      subject {DummyComment.new(nil, nil, 2, nil)}

      it {should be_invalid}
    end
  end
end
