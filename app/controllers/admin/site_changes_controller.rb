class Admin::SiteChangesController < ApplicationController
  layout 'admin'

  def index
    @site_changes = SiteChange.page params[:page]
  end

  def create
    SiteChange.create params[:site_change]
    redirect_to '/admin/site_changes'
  end
end