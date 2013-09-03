class MistsController < ApplicationController
  def index
  end

  def create
    @mist = Mist.new(params[:mist])

    if @mist.save
      redirect_to @mist
    end
  end

  def edit
    @mist = Mist.find(params[:id])
  end

  def update
    @mist = Mist.find(params[:id])

    if @mist.update_attributes(params[:mist])
      redirect_to @mist
    end
  end

  def show
    @mist = Mist.find(params[:id])
  end
end