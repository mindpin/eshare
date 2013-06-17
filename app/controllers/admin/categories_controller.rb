class Admin::CategoriesController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'

  before_filter :pre_load

  def pre_load
    @category = Category.find(params[:id]) if params[:id]
  end

  def index
    @categories = Category.roots
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to "/admin/categories"
    end
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to "/admin/categories"
    end
  end

  def destroy
    @category.destroy
    redirect_to :back
  end

  def do_import
    file = params['yaml_file']
    Category.save_yaml(file)

    redirect_to "/admin/categories"
  end

  
end