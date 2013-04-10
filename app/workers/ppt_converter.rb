class PPTConverter
  include Sidekiq::Worker

  def perform(entity_id)
    ppt_entity = FileEntity.find(entity_id)
    @_path = ppt_entity.attach.path
    converter = Odocuconv::Converter.new(R::LIBREOFFICE_PATH)
    converter.start
    converter.convert(@_path, ppt_entity.convert_ppt_output_index_html)
    converter.stop
    ppt_entity.convert_success!
  rescue
    ppt_entity.convert_failed!
    converter.stop
  end

  def self.sidekiq_running?
    `ps aux | grep sidekiq`.split("\n").select {|process| process.include? 'busy'}.present?
  end
end
