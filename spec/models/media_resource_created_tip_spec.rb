require 'spec_helper'

describe '根据个人网盘中文件名进行一些提示' do
  context '文件名和公共网盘内的某个分类目录名存在匹配。提示是否可以把该文件分享到该目录' do
    before{
      @category = FactoryGirl.create(:category, :name => "JAVA")
      @media_resource = FactoryGirl.create(:media_resource, :file, :name => "java.ppt")
    }

    it{
      @media_resource.create_tips.count.should == 1
    }

    it{
      @media_resource.create_tips.first.kind.should == MediaResourceCreatedTip::MATCH_CATEGORY_NAME
    }

    it{
      @media_resource.create_tips.first.info[:category_ids].should == [@category.id]
    }
  end

  context '文件名和公共网盘内的某个文件名存在匹配，提示是否有兴趣查看该公共文件资源' do
    before{
      @category = FactoryGirl.create(:category)
      @media_resource_1 = FactoryGirl.create(:media_resource, :file, :name => "java.ppt", :category => @category)
      @media_resource_2 = FactoryGirl.create(:media_resource, :file, :name => "java.ppt")

      @media_resource = FactoryGirl.create(:media_resource, :file, :name => "java.ppt")
    }

    it{
      @media_resource.create_tips.count.should == 1
    }

    it{
      @media_resource.create_tips.first.kind.should == MediaResourceCreatedTip::MATCH_PUBLIC_RESOURCE_NAME
    }

    it{
      @media_resource.create_tips.first.info[:media_resource_ids].should == [@media_resource_1.id]
    }

  end

  context '文件名公共网盘内的任何文件名都不匹配，提示是否要分享到公共网盘' do
    before{
      @media_resource = FactoryGirl.create(:media_resource, :file, :name => "java.ppt")
    }

    it{
      @media_resource.create_tips.count.should == 1 
    }

    it{
      @media_resource.create_tips.first.kind.should == MediaResourceCreatedTip::MATCH_NOTHING
    }
  end

  context '综合测试' do
    before{
      @category_shouji  = FactoryGirl.create(:category, :name => "手机")
      @category_shouji_pingguo = FactoryGirl.create(:category, :name => "苹果", :parent => @category_shouji)

      @category_shuiguo = FactoryGirl.create(:category, :name => "水果")
      @category_shuiguo_pingguo = FactoryGirl.create(:category, :name => "苹果", :parent => @category_shuiguo)
    }

    context '上传一个文件 名字是 梨' do
      before{
        @media_resource_1 = FactoryGirl.create(:media_resource, :file, :name => "梨")
      }

      it{
        @media_resource_1.create_tips.count.should == 1 
      }

      it{
        @media_resource_1.create_tips.first.kind.should == MediaResourceCreatedTip::MATCH_NOTHING
      }

      context '再上传一个文件 名字是 梨' do
        before{
          @media_resource_li = FactoryGirl.create(:media_resource, :file, :name => "梨")
        }

        it{
          @media_resource_li.create_tips.count.should == 1 
        }

        it{
          @media_resource_li.create_tips.first.kind.should == MediaResourceCreatedTip::MATCH_NOTHING
        }
      end

      context '上传一个文件 名字是 苹果' do
        before{
          @media_resource_2 = FactoryGirl.create(:media_resource, :file, :name => "苹果")
        }

        it{
          @media_resource_2.create_tips.count.should == 1 
        }

        it{
          @media_resource_2.create_tips.first.kind.should == MediaResourceCreatedTip::MATCH_CATEGORY_NAME
        }

        it{
          @media_resource_2.create_tips.first.info[:category_ids].should =~ [@category_shouji_pingguo.id, @category_shuiguo_pingguo.id]
        }

        context '共享上一个文件，上传一个新文件 名字是苹果' do
          before{
            @media_resource_2.to_public(@category_shuiguo)

            @media_resource_3 = FactoryGirl.create(:media_resource, :file, :name => "苹果")
          }

          it{
            @media_resource_3.create_tips.map(&:kind) =~ [MediaResourceCreatedTip::MATCH_CATEGORY_NAME, MediaResourceCreatedTip::MATCH_PUBLIC_RESOURCE_NAME]
          }

          it{
            tip = @media_resource_3.create_tips.select{|tip|tip.kind == MediaResourceCreatedTip::MATCH_CATEGORY_NAME}[0]
            tip.info[:category_ids].should =~ [@category_shouji_pingguo.id, @category_shuiguo_pingguo.id]
          }

          it{
            tip = @media_resource_3.create_tips.select{|tip|tip.kind == MediaResourceCreatedTip::MATCH_PUBLIC_RESOURCE_NAME}[0]
            tip.info[:media_resource_ids].should =~ [@media_resource_2.id]
          }
        end
      end
    end
  end
end

