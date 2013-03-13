rb_path = Rails.root.join('deploy/sh/parse_property.rb')
MINDPIN_MRS_DATA_PATH = `ruby #{rb_path} MINDPIN_MRS_DATA_PATH`

FILE_ENTITY_ATTACHED_PATH     = "#{MINDPIN_MRS_DATA_PATH}/attachments/:attachment/:id/:style/:filename"
FILE_ENTITY_ATTACHED_URL      = "/attachments/:attachment/:id/:style/:filename"
