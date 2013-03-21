class DiskController < ApplicationController
  before_filter :authenticate_user!

  def index
    @current_dir_path = _current_dir_path
    @media_resources = MediaResource.gets current_user, @current_dir_path
  end

  def create
    file_entity = FileEntity.find params[:file_entity_id]
    path = params[:path]

    resource = MediaResource.put_file_entity current_user, path, file_entity

    render :json => {
      :id => resource.id,
      :name => resource.name
    }
  end

  private
    def _current_dir_path
      path = request.path[5..-1]
      path = '/' if path.blank?
      path
    end
end