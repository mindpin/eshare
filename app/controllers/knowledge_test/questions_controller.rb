class KnowledgeTest::QuestionsController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'flat-grid'
  end

  def index
    @questionss = nil
  end

  def show
    @question = nil
  end
end