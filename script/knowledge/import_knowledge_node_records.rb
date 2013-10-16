p "准备导入 JAVASCRIPT_CORE 到 knowledge_node_records"
net = KnowledgeNet::JAVASCRIPT_CORE
net_id = net.id
nodes = net.knowledge_nodes
all_count = nodes.count

begin
  KnowledgeNodeRecord.transaction do
    
    net.knowledge_nodes.each_with_index do |node,index|
      p "已完成 #{index+1}/#{all_count}"

      node_id = node.id
      KnowledgeNodeRecord.create!(
        :knowledge_node_id => node_id, 
        :knowledge_net_id  => net_id
      )
    end
    
  end
rescue Exception => ex
  puts "*** transaction abored!"
  puts "*** errors: #{ex.message}"
end
