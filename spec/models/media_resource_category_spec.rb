require 'spec_helper'

describe '公共网盘' do
  context '共享个人网盘中的文件到公共网盘' do
    before{
      media_resource = FactoryGirl.create(:media_resource,:file)
      @category = FactoryGirl.create(:category)
      
      media_resource.to_public(@category)
      @media_resource = MediaResource.find(media_resource.id)
    }

    it{
      @media_resource.category.should == @category
    }

    it{
      MediaResource.publics.should =~ [@media_resource]
    }

    it{
      MediaResource.publics.by_category(@category).should =~ [@media_resource]
    }
  end

  context '查询公共网盘分类目录下的文件' do
    before{
      @category = FactoryGirl.create(:category)
      @category_1 = FactoryGirl.create(:category, :parent => @category)
    }
    it{
      MediaResource.publics.count.should == 0 
    }

    it{
      MediaResource.publics.by_category(@category).count == 0
    }
    context '共享一些文件到公共网盘,再次查询分类目录下的文件' do
      before{
        @media_resource_1 = FactoryGirl.create(:media_resource,:file)
        @media_resource_2 = FactoryGirl.create(:media_resource,:file)
        @media_resource_3 = FactoryGirl.create(:media_resource,:file)
        @media_resource_4 = FactoryGirl.create(:media_resource,:file)

        @media_resource_1.to_public(@category)
        @media_resource_2.to_public(@category_1)
        @media_resource_3.to_public(@category)
      }

      it{
        MediaResource.publics.count.should == 3
      }

      it{
        MediaResource.by_category(@category).should =~ [@media_resource_1,@media_resource_3]
      }

      it{
        MediaResource.by_category(@category_1).should =~ [@media_resource_2]
      }
    end
  end
end