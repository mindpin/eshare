require 'nokogiri'
require 'fileutils'

file_path = ARGV[0]
id_prefix = ARGV[1] || ""
raise "#{file_path} 文件不存在" if !File.exists?(file_path)

path =  File.dirname(file_path)
basename = File.basename(file_path,".graphml")

# build_path = Rails.root.join("config/knowledge_nets/#{basename}.xml")
base_path = File.expand_path("../../../",__FILE__)
build_path = File.join(base_path, "config/knowledge_nets/#{basename}.xml")


doc = Nokogiri::XML(File.open(file_path))
# graph
#   node(:id)
#     data[key=d5].content
#     data[key=d6]
#       y:ShapeNode
#         y:NodeLabel.content
nodes = doc.css("graph node").map do |node|
  id = id_prefix + node.attr('id')
  name = node.at_css("data[key='d6'] y|ShapeNode y|NodeLabel").text().gsub(/\s/,"")
  desc = node.at_css("data[key='d5']").text()
  {:id=> id, :name => name,:desc=>desc}
end

# graph
#   edge(:source=> parent_id, :target => child_id)
relactions = doc.css("graph edge").map do |edge|
  parent_id = id_prefix + edge.attr("source")
  child_id = id_prefix + edge.attr("target")
  {:parent_id => parent_id, :child_id => child_id}
end

# <KnowledgeNet>
#   <nodes>
#     <node id="k1">
#       <name>xxx<name>
#       <desc>xxx</desc>
#     </node>
#   </nodes>

#   <relations>
#     <relation>
#       <parent node_id="k1"/>
#       <child node_id="k3"/>
#     </relation>
#   </relations>
# </KnowledgeNet>

builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
  xml.KnowledgeNet{
    xml.nodes{
      nodes.each do |node|
        xml.node(:id=>node[:id]){
          xml.name(node[:name])
          xml.desc(node[:desc])
        }
      end
    }
    xml.relations{
      relactions.each do |relation|
        xml.relation{
          xml.parent_(:node_id => relation[:parent_id])
          xml.child_(:node_id => relation[:child_id])
        }
      end
    }
  }
end

result_xml = builder.to_xml(:encoding => 'UTF-8')
FileUtils.mkdir_p(File.dirname(build_path))
File.open(build_path,"w:UTF-8"){|f|f<<result_xml}
p "成功生成 #{build_path}"