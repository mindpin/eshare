class ChangeVideoEncodeStatusToConvertStatusInFileEntities < ActiveRecord::Migration
  def change
    rename_column :file_entities, :video_encode_status, :convert_status
  end
end
