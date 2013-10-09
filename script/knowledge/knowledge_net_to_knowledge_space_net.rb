

file_path = ARGV[0]
raise "#{file_path} 文件不存在" if !File.exists?(file_path)

file_name = File.basename(file_path)
build_path = Rails.root.join("config/knowledge_space_nets/#{file_name}")

knowledge_net = KnowledgeNet.load_xml_file(file_path)
knowledge_space_net = KnowledgeSpaceParser.new(knowledge_net).parse
knowledge_space_net.save_to(build_path)
p "成功生成 #{build_path}"