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

  def destroy
    MediaResource.del current_user, params[:path]
    return _after_remove
  rescue MediaResource::InvalidPathError
    return _after_remove
  end

  private
    def _current_dir_path
      path = request.path[5..-1]
      path = '/' if path.blank?
      path
    end

    def _parent_path(path)
      path.split('/')[0...-1].join('/')
    end

    def _after_remove
      if request.xhr?
        render :text => 'deleted.'
        return
      end

      parent_path = _parent_path params[:path]
      to_path = parent_path.blank? ? '/disk' : File.join('/disk', parent_path)
      redirect_to to_path
    end
end