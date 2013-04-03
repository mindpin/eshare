require "spec_helper"

describe Category do

  describe "YAML 数据导入" do
    before {
      Category.save_yaml('spec/data/categories.yaml')

      
      @root_nodes = Category.roots.map { |c| c.name }
      @second_nodes = @root_nodes.map { |c|  }
    }

    it "根目录" do
      @root_nodes.should == ["microsoft", "Linux"]
    end

    it "第二级目录" do
    end

    it "第三级目录" do
    end
  end

end