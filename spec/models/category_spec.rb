require "spec_helper"

describe Category do

  describe "YAML 数据导入" do
    before {
      path = 'spec/data/categories.yaml'
      file = File.new(path)

      Category.save_yaml(file)

      @root_nodes = Category.roots

      @microsoft_nodes = @root_nodes.first.children
      @linux_nodes = @root_nodes.second.children

      @slackware_nodes = @linux_nodes.first.children
      @debian_nodes = @linux_nodes.second.children

      @xp_nodes = @microsoft_nodes.first.children
      @vista_nodes = @microsoft_nodes.second.children
      @windows8_nodes = @microsoft_nodes.third.children
    }

    it "检查数目" do
      Category.count.should == 17
    end

    it "根目录" do
      categories = @root_nodes.map { |c| c.name }
      categories.should == ['microsoft', 'Linux']
    end

    it "第一级是根目录" do
      @root_nodes.each do |node|
        node.root?.should == true
      end
    end

    it "第二级 microsoft 目录" do
      @microsoft_nodes.map { |c| c.name }.should == ['xp', 'vista', 'windows8']
    end

    it "第二级 linux 目录" do
      @linux_nodes.map { |c| c.name }.should == ['slackware', 'debian']
    end

    it "第三级 xp 目录" do
      @xp_nodes.map { |c| c.name }.should == ['2003', '2004']
    end

    it "第三级 vista 目录" do
      @vista_nodes.map { |c| c.name }.should == ['2005', '2006']
    end

    it "第三级 windows8 目录" do
      @windows8_nodes.map { |c| c.name }.should == ['2010', '2011']
    end

    it "第三级 slackware 目录" do
      @slackware_nodes.map { |c| c.name }.should == ['test', 'alpha']
    end

    it "第三级 debian 目录" do
      @debian_nodes.map { |c| c.name }.should == ['etch', 'squeeze']
    end

    it "第三级是最后一级" do
      nodes = @xp_nodes + @vista_nodes + @windows8_nodes + @slackware_nodes + @debian_nodes
      nodes.each do |node|
        node.leaf?.should == true
      end
    end

    
  end

end