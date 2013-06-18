class TestPaperItemsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @paper_item = TestPaperItem.find(params[:id])
    @paper_item.update_attributes params[:test_paper_item]
    redirect_to :back
  end
end