class FilesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # params like:
  #   file_entity_id : 1 ( or nil )
  #        file_name : 'abc.zip'
  #        file_size : 345874
  #       start_byte : 1024
  #             blob : #### form_data ####

  def upload
    file_entity = _find_or_build_file_entity
    exist = _find_exist_file_entity(file_entity)

    file_entity = exist.blank? ? file_entity : exist
    file_entity.save

    # here
    if params[:start_byte].to_i == file_entity.saved_size
      file_entity.save_blob(params[:blob])
    end

    render :json => _build_json(file_entity)

  rescue FilePartUpload::AlreadyMergedError
    render :text => 'file already merged.', :status => 500
  rescue
    render :text => 'params or other error.', :status => 500
  end

  private
    def _find_or_build_file_entity
      file_entity_id = params[:file_entity_id]
      return _build_file_entity if file_entity_id.blank?

      file_entity = FileEntity.find_by_id(file_entity_id)
      return _build_file_entity if file_entity.blank?

      return file_entity
    end

    def _build_file_entity
      return FileEntity.new({
        :attach_file_name => params[:file_name],
        :attach_file_size => params[:file_size]
      })
    end

    def _find_exist_file_entity(file_entity)
      return FileEntity.where(
        'attach_file_name = ? AND attach_file_size = ?',
        file_entity.attach_file_name, 
        file_entity.attach_file_size
      ).first
    end

    def _build_json(file_entity)
      return {
        :file_entity_id => file_entity.id,
        :saved_size     => file_entity.saved_size
      }
    end
end