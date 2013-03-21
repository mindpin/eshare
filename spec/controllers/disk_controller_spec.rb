require 'spec_helper'

describe DiskController do
  before {
    @user = FactoryGirl.create(:user, :teacher, :name => '狄仁杰')
    @another_user = FactoryGirl.create(:user, :student, :name => '元芳')
  }

  context '增删' do
    before {
      @file_entity = FileEntity.create({
        :attach => File.new(Rails.root.join('spec/data/upload_test_files/test1024.file'))
      })

      sign_in @user

      post :create, :file_entity_id => FileEntity.last.id,
                    :path => '/foo.txt'

      @json = JSON::parse(response.body)
    }

    describe '#create' do
      it {
        MediaResource.count.should == 1
      }

      it 'should have file entity' do
        MediaResource.last.file_entity.should == @file_entity
      end

      it 'should have creator' do
        MediaResource.last.creator.should == @user
      end

      it {
        @json['id'].should == MediaResource.last.id
      }

      it {
        @json['name'].should == 'foo.txt'
      }
    end

    describe '#destroy' do
      it {
        expect { 
          delete :destroy, :path => '/foo.txt'
        }.to change{ 
          MediaResource.count
        }.by(-1)
      }

      it {
        delete :destroy, :path => '/foo.txt'
        response.should redirect_to '/disk'
      }

      context '试图删除不存在的文件，直接重定向' do
        it {
          expect { 
            delete :destroy, :path => '/a/b/c/foo.txt'
          }.to change{ 
            MediaResource.count
          }.by(0)
        }

        it {
          delete :destroy, :path => '/abc/def/foo.txt'
          response.should redirect_to '/disk/abc/def'
        }

        it {
          delete :destroy, :path => '/d/e/f/g/h/i.j'
          response.should redirect_to '/disk/d/e/f/g/h'
        }
      end

      context 'ajax 删除' do
        it {
          expect { 
            xhr :delete, :destroy, :path => '/foo.txt'
          }.to change{ 
            MediaResource.count
          }.by(-1)
        }

        it {
          xhr :delete, :destroy, :path => '/foo.txt'
          response.body.should == 'deleted.'
        }
      end
    end
  end
end