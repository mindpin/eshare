require "spec_helper"

describe Category do

  describe "YAML 数据导入" do
    before {
      file = 'spec/data/categories.yaml'

      Category.save_yaml(file)

      @root_nodes = Category.roots.map { |c| c.name }

      @microsoft = @root_nodes.first
      @linux = @root_nodes.last

      @nodes = Category.get_nodes(file)
      @slackware = @nodes[@linux].keys.first
      @debian = @nodes[@linux].keys.last
    }

    it "根目录" do
      @root_nodes.should == ["microsoft", "Linux"]
    end

    it "第二级 microsoft 目录" do
      @nodes[@microsoft].keys.should == ['xp', 'vista', 'windows8']
    end

    it "第二级 linux 目录" do
      @nodes[@linux].keys.should == ['slackware', 'debian']
    end

    it "第三级 debian 目录" do
      @nodes[@linux][@debian].keys.should == ['etch', 'squeeze']
    end

    it "第三级 slackware 目录" do
      @nodes[@linux][@slackware].keys.should == ['test', 'alpha']
    end
  end

end