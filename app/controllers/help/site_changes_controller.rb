class Help::SiteChangesController < ApplicationController
  layout 'help'

  def index
    @site_changes = SiteChange.order('id DESC').page params[:page]
  end
end