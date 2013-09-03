class MistsController < ApplicationController
  def index
  end

  def create
    @mist = Mist.new(params[:mist])

    if @mist.save
      redirect_to @mist
    end
  end

  def show
    @mist = Mist.find(params[:id])
  end
end