require 'spec_helper'

describe MediaShare do
  before do
    @resource = FactoryGirl.create :media_resource
    @sharer   = @resource.creator
    @receiver = FactoryGirl.create :receiver
  end

  describe MediaShare::MediaResourceMethods do
    def share
      @resource.share_to @receiver
    end

    describe '#share_to' do
      context 'when media_resource hasn\'t been shared to receiver' do
        it 'shares media_resource to receiver' do
          expect {share}.to change {@receiver.received_media_shares.count}.by(1)
        end
      end

      context 'when media_resource has already been shared to receiver' do
        it 'forbids sharing the same media_resource to the same receiver more than once' do
          expect {2.times {share}}.to raise_error(MediaShare::DuplicateShareNotAllowed)
        end
      end
    end

    describe '#shared_receivers' do
      subject {@resource.shared_receivers}

      context 'when some one is shared' do
        before {share}

        its(:first) {should eq @receiver}
      end

      context 'when no one is shared' do
        its(:first) {should be nil}
      end
    end
  end

  describe MediaShare::UserMethods do
    describe '#shared_media_resources' do
      before  {@creator = FactoryGirl.create :user}
      subject {@creator.shared_media_resources}
      context 'when user has shared media_resource to somepeole' do
        before do
          @resource1, @resource2 = 2.times.map do
            FactoryGirl.create :media_resource, :creator => @creator
          end

          @user1, @user2 = 2.times.map do
            FactoryGirl.create :user
          end

          [@resource1, @resource2].each do |resource|
            [@user1, @user2].each do |receiver|
              resource.share_to receiver
            end
          end
        end

        its(:count) {should be 2}
        its(:first) {should eq @resource1}
      end

      context 'when user hasn\'t shared anything yet' do
        its(:first) {should be nil}
      end
    end

    describe '#received_media_resources' do
      subject {@receiver.received_media_resources}

      context 'when receiver has received media resources' do
        before do
          4.times do
            FactoryGirl.create(:media_resource).share_to @receiver
          end
        end

        its(:first) {should be_a MediaResource}
        its(:count) {should be 4}
      end

      context 'when receiver hasn\'t received any media resources' do
        its(:first) {should be nil}
      end
    end

    context 'from and to pairs' do
      before {@resource.share_to @receiver}

      describe '#shared_media_resources_to_receiver' do
        subject {@sharer.shared_media_resources_to_receiver(@receiver)}

        its(:count) {should be 1}
        it 'contains shared media resources from sharer to receiver' do
          subject.should include @resource
          @resource.shared_receivers.should include @receiver
        end
      end

      describe '#received_media_resources_from_sharer' do
        subject {@receiver.received_media_resources_from_sharer(@sharer)}

        its(:count) {should be 1}
        it 'contains received media resources to receiver from sharer' do
          subject.should include @resource
          @resource.shared_receivers.should include @receiver
        end
      end
    end

    describe '#received_media_sharers' do
      before  {@resource.share_to(@receiver)}
      subject {@receiver.received_media_sharers}

      its(:count) {should be 1}
      it {should include @sharer}
    end

    describe '#received_media_resources_infos' do
      before      {@resource.share_to(@receiver)}
      let(:infos) {@receiver.received_media_resources_infos}
      subject     {infos}

      its(:count) {should be 1}
      its(:first) {should be_a ReceivedMediaResourcesInfo}

      describe ReceivedMediaResourcesInfo do
        subject {infos.first}

        its(:sharer) {should eq @sharer}
        its(:media_resources) {should include @resource}
      end
    end
  end
end
