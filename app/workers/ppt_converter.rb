class PPTConverter
  include Sidekiq::Worker

  def perform(entity_id)
    ppt_entity = FileEntity.find(entity_id)
    @_path = ppt_entity.attach.path
    converter = Odocuconv::Converter.new('/opt/libreoffice3.6')
    converter.start
    converter.convert(@_path, ppt_entity.convert_ppt_path)
    converter.stop
    ppt_entity.convert_success!
  rescue
    ppt_entity.convert_failed!
    converter.stop
  end

end
