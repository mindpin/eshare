class Admin::CategoriesController < ApplicationController
  layout 'admin'

  before_filter :pre_load

  def pre_load
    @category = Category.find(params[:id]) if params[:id]
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end