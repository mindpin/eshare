require 'spec_helper'

describe DiskController do
  describe '#create' do
    before {
      @user = FactoryGirl.create(:user, :teacher, :name => '狄仁杰')

      @file_entity = FileEntity.create({
        :attach => File.new(Rails.root.join('spec/data/upload_test_files/test1024.file'))
      })

      sign_in @user

      post :create, :file_entity_id => FileEntity.last.id,
                    :path => '/foo.txt'

      @json = JSON::parse(response.body)
    }

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
end