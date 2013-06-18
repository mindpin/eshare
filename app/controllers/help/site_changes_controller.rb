class Help::SiteChangesController < ApplicationController
  layout 'help'

  def index
    @site_changes = SiteChange.page params[:page]
  end
end