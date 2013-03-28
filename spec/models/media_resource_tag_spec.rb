require 'spec_helper'

describe MediaResource do
  before{
    @user_1 = FactoryGirl.create(:user)
    @user_2 = FactoryGirl.create(:user)
  }

  describe '标记TAG' do
    before{
      @media_resource = FactoryGirl.create(:media_resource, :file)
      @creator = @media_resource.creator
    }

    it{
      @media_resource.public_tags.should == []
    }

    it{
      @media_resource.private_tags(@user_1).should == []
    }

    it{
      @media_resource.private_tags(@creator).should == []
    }

    describe 'media_resource_creator 可以给 media_resource 标记TAG。凡是creator标记的TAG，直接作为公共TAG' do
      context 'set_tag_list(str)' do
        before{
          @media_resource.set_tag_list("编程,java，api 教程")  
        }

        it{
          @media_resource.public_tags.map(&:name).should =~ ['编程','java','api','教程'] 
        }

        it{
          @media_resource.private_tags(@user_1).should == []
        }

        it{
          @media_resource.private_tags(@creator).map(&:name).should =~ ['编程','java','api','教程']
        }
      end

      context 'set_tag_list(str,:user=> creator)' do
        before{
          @media_resource.set_tag_list("编程,java，api 教程", :user => @media_resource.creator)  
        }

        it{
          @media_resource.public_tags.map(&:name).should =~ ['编程','java','api','教程'] 
        }

        it{
          @media_resource.private_tags(@user_1).should == []
        }

        it{
          @media_resource.private_tags(@creator).map(&:name).should =~ ['编程','java','api','教程']
        }
      end
    end
    
    describe '所有非 media_resource_creator 的其他人，都可以给 media_resource 标记TAG。凡是非 media_resource_creator 标记的TAG，不作为公共TAG，只影响标记者的查询结果。' do
      context 'set_tag_list(str,:user => user)' do
        before{
          @media_resource.set_tag_list("编程,java，api 教程", :user => @user_1)
        }

        it{
          @media_resource.public_tags.should == []
        }

        it{
          @media_resource.private_tags(@user_1).map(&:name).should =~ ['编程','java','api','教程'] 
        }
      end
    end

    describe '如果恰巧有两个或两个以上（>1）的非资源creator对某个资源标记了同名TAG，则该TAG被作为公共TAG；' do
      before{
        @media_resource.set_tag_list("编程,java，api", :user => @user_1)
        @media_resource.set_tag_list("java，api 教程", :user => @user_2)
      }

      it{
        @media_resource.public_tags.map(&:name).should =~ ['java','api'] 
      }

      it{
        @media_resource.private_tags(@user_1).map(&:name).should =~ ['编程','java','api'] 
      }

      it{
        @media_resource.private_tags(@user_2).map(&:name).should =~ ['java','api','教程']
      }

      it{
        @media_resource.private_tags(@creator).should == []
      }

      context '如果一个公共TAG，是被多于一个人（非 creator）标记才变为的公共TAG，当人数变为少于两人时，取消该TAG的公共属性' do
        before{
          @media_resource.set_tag_list("java", :user => @user_2)
        }

        it{
          @media_resource.private_tags(@user_2).map(&:name).should =~ ['java']
        }

        it{
          @media_resource.public_tags.map(&:name).should =~ ['java']
        }

        context 'creator 重新标记TAG' do
          before{
            @media_resource.set_tag_list("api")
            @media_resource.set_tag_list("java 编程", :user => @user_1)
          }

          it{
            @media_resource.private_tags(@user_1).map(&:name).should =~ ['java','编程']
          }

          it{
            @media_resource.private_tags(@user_2).map(&:name).should =~ ['java'] 
          }

          it{
            @media_resource.private_tags(@creator).map(&:name).should =~ ['api']
          }

          it{
            @media_resource.public_tags.map(&:name).should =~ ['java','api']
          }
        end
      end
    end

    describe '#set_tag_list' do
      context '大小写' do
        before {
          @media_resource.set_tag_list 'AJAX,Java,W3C', :user => @creator
        }

        it {
          @media_resource.public_tags.map(&:name).
            should =~ %w(ajax w3c java)
        }

        it {
          @media_resource.private_tags(@creator).map(&:name).
            should =~ %w(ajax w3c java)
        }
      end

      context '重复检查' do
        before {
          @media_resource.set_tag_list 'AJAX,Java,W3C,abc,ABC,aBC', :user => @creator
        }

        it {
          @media_resource.public_tags.map(&:name).
            should =~ %w(ajax w3c java abc)
        }

        it {
          @media_resource.private_tags(@creator).map(&:name).
            should =~ %w(ajax w3c java abc)
        }
      end
    end

    describe '#update_public_tags' do
      before {
        @user_a = FactoryGirl.create(:user)
        @user_b = FactoryGirl.create(:user)

        @media_resource.set_tag_list '苹果,橘子,香蕉', :user => @creator
      }

      it {
        @media_resource.public_tags.map(&:name).
          should =~ %w(苹果 香蕉 橘子)
      }

      it { @media_resource.private_tags(@user_a).should be_blank }

      it { @media_resource.private_tags(@user_b).should be_blank }

      context '第一个非所有者添加了tag' do
        before {
          @media_resource.set_tag_list '西瓜,芒果,猕猴桃', :user => @user_a
        }

        it {
          @media_resource.public_tags.map(&:name).
            should =~ %w(苹果 香蕉 橘子)
        }

        it {
          @media_resource.private_tags(@user_a).map(&:name).
            should =~ %w(芒果 西瓜 猕猴桃)
        }

        it { @media_resource.private_tags(@user_b).should be_blank }

        context '第二个非所有者添加了tag' do
          before {
            @media_resource.set_tag_list '西瓜,草莓,火龙果', :user => @user_b
          }

          it {
            @media_resource.public_tags.map(&:name).
              should =~ %w(苹果 香蕉 西瓜 橘子)
          }

          it {
            @media_resource.private_tags(@user_a).map(&:name).
              should =~ %w(芒果 西瓜 猕猴桃)
          }

          it {
            @media_resource.private_tags(@user_b).map(&:name).
              should =~ %w(火龙果 西瓜 草莓)
          }

          context '第一个非所有者移除了tag' do
            before {
              @media_resource.set_tag_list '橄榄', :user => @user_a
            }

            it {
              @media_resource.public_tags.map(&:name).
                should =~ %w(苹果 香蕉 橘子)
            }

            it {
              @media_resource.private_tags(@user_a).map(&:name).
                should =~ %w(橄榄)
            }

            it {
              @media_resource.private_tags(@user_b).map(&:name).
                should =~ %w(火龙果 西瓜 草莓)
            }
          end
        end
      end
    end
  end

  describe '根据TAG查询' do
    before{
      @media_resource_1 = FactoryGirl.create(:media_resource, :file)
      @media_resource_2 = FactoryGirl.create(:media_resource, :file)
      @media_resource_3 = FactoryGirl.create(:media_resource, :file)
      @media_resource_4 = FactoryGirl.create(:media_resource, :file)

      @media_resource_1.set_tag_list('java,api')
      @media_resource_4.set_tag_list('java')

      @media_resource_1.set_tag_list('java', :user => @user_1)
      @media_resource_2.set_tag_list('java,api', :user => @user_1)

      @media_resource_2.set_tag_list('java', :user => @user_2)
      @media_resource_3.set_tag_list('java', :user => @user_2)      
    }

    it{
      @media_resource_1.public_tags.map(&:name).should =~ ['java','api']
      @media_resource_1.private_tags(@user_1).map(&:name).should =~ ['java']
      @media_resource_1.private_tags(@user_2).should == []

      @media_resource_2.public_tags.map(&:name).should =~ ['java']
      @media_resource_2.private_tags(@user_1).map(&:name).should =~ ['java','api']
      @media_resource_2.private_tags(@user_2).map(&:name).should =~ ['java']

      @media_resource_3.public_tags.should == []
      @media_resource_3.private_tags(@user_1).should == []
      @media_resource_3.private_tags(@user_2).map(&:name).should =~ ['java']

      @media_resource_4.public_tags.map(&:name).should =~ ['java']
      @media_resource_4.private_tags(@user_1).should == []
      @media_resource_4.private_tags(@user_2).should == []
    }

    it{
      MediaResource.by_tag('java').should =~ [@media_resource_1, @media_resource_2, @media_resource_4]
    }

    it{
      MediaResource.by_tag('java', :user => @user_1) =~ [@media_resource_1, @media_resource_2, @media_resource_4]
    }

    it{
      MediaResource.by_tag('java', :user => @user_2) =~ [@media_resource_1, @media_resource_2, @media_resource_3, @media_resource_4]
    }

    it{
      MediaResource.by_tag('api').should =~ [@media_resource_1]
    }

    it{
      MediaResource.by_tag('api', :user => @user_1).should =~ [@media_resource_1,@media_resource_2]
    }

    it{
      MediaResource.by_tag('api', :user => @user_2).should =~ [@media_resource_1]
    }

    context '#private_tagged_count' do
      before{
        @tag_java = Tag.by_name('java').first
        @tag_api = Tag.by_name('api').first
      }

      it{
        @media_resource_1.private_tagged_count(@tag_java).should == 2
      }

      it{
        @media_resource_1.private_tagged_count(@tag_api).should == 1 
      }

      it{
        @media_resource_2.private_tagged_count(@tag_java).should == 2
      }

      it{
        @media_resource_2.private_tagged_count(@tag_api).should == 1
      }

      it{
        @media_resource_3.private_tagged_count(@tag_java).should == 1
      }

      it{
        @media_resource_3.private_tagged_count(@tag_api).should == 0
      }

      it{
        @media_resource_4.private_tagged_count(@tag_java).should == 1
      }

      it{
        @media_resource_4.private_tagged_count(@tag_api).should == 0
      }
    end

    context 'tagged_with_creator' do
      before{
        @tag_java = Tag.by_name('java').first
        @tag_api = Tag.by_name('api').first
      }

      it{
        @media_resource_1.tagged_with_creator?(@tag_java).should == true
      }

      it{
        @media_resource_1.tagged_with_creator?(@tag_api).should == true
      }

      it{
        @media_resource_2.tagged_with_creator?(@tag_java).should == false
      }

      it{
        @media_resource_2.tagged_with_creator?(@tag_api).should == false
      }

      it{
        @media_resource_3.tagged_with_creator?(@tag_java).should == false
      }

      it{
        @media_resource_3.tagged_with_creator?(@tag_api).should == false
      }

      it{
        @media_resource_4.tagged_with_creator?(@tag_java).should == true
      }

      it{
        @media_resource_4.tagged_with_creator?(@tag_api).should == false
      }
    end
  end
end