require 'spec_helper'

describe TagsController do
  before {
    @media_resource = FactoryGirl.create :media_resource, :file

    @creator = @media_resource.creator
    @another_user = FactoryGirl.create :user
  }

  describe '#update' do
    context '不登陆，不能改' do
      before {
        put :set_tags, :tagable_id => @media_resource.id,
                       :tagable_type => @media_resource.class.to_s,
                       :tags => '苹果，香蕉，橘子 西瓜'
      }

      it {
        response.code.should == '302'
      }

      it {
        @media_resource.public_tags.should be_blank
        @media_resource.private_tags(@creator).should be_blank
        @media_resource.private_tags(@another_user).should be_blank
      }
    end

    context '登陆' do
      context '资源所有者' do
        before {
          sign_in @creator
          put :set_tags, :tagable_id => @media_resource.id,
                         :tagable_type => @media_resource.class.to_s,
                         :tags => '苹果，香蕉，橘子 西瓜'
        }

        it {
          response.code.should == '200'
        }

        it {
          @media_resource.public_tags.map(&:name).
            should =~ %w(苹果 香蕉 橘子 西瓜)
        }

        it {
          @media_resource.private_tags(@creator).map(&:name).
            should =~ %w(苹果 香蕉 橘子 西瓜)
        }

        it {
          @media_resource.private_tags(@another_user).map(&:name).
            should be_blank
        }

        context '非资源所有者，添加私有TAG' do
          before {
            sign_out @creator
            sign_in @another_user
            put :set_tags, :tagable_id => @media_resource.id,
                           :tagable_type => @media_resource.class.to_s,
                           :tags => '草莓，柠檬，菠萝 芒果'
          }

          it {
            response.code.should == '200'
          }

          it {
            @media_resource.public_tags.map(&:name).
              should =~ %w(苹果 香蕉 橘子 西瓜)
          }

          it {
            @media_resource.private_tags(@creator).map(&:name).
              should =~ %w(苹果 香蕉 橘子 西瓜)
          }

          it {
            @media_resource.private_tags(@another_user).map(&:name).
              should =~ %w(草莓 芒果 柠檬 菠萝)
          }
        end
      end

      context '非资源所有者' do
        before {
          sign_in @another_user
          put :set_tags, :tagable_id => @media_resource.id,
                         :tagable_type => @media_resource.class.to_s,
                         :tags => '草莓，柠檬，菠萝 芒果'
        }

        it {
          response.code.should == '200'
        }

        it {
          @media_resource.public_tags.should be_blank
        }

        it {
          @media_resource.private_tags(@another_user).map(&:name).
            should =~ %w(草莓 芒果 柠檬 菠萝)
        }
      end
    end
  end
end