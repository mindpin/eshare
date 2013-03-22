class PPTConverter
  include Sidekiq::Worker

  def perform(entity_id)
    ppt_entity = FileEntity.find(entity_id)
    @_path = ppt_entity.attach.path
    converter = Odocuconv::Converter.new('/usr/lib/libreoffice')
    converter.start
    converter.convert(@_path, output_path)
    converter.stop
  end

  def output_path
    File.join(File.dirname(@_path), File.basename(@_path, '.ppt')) + '.swf'
  end
end
