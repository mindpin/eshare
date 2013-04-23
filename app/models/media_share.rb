class MediaShare < ActiveRecord::Base
  attr_accessible :media_resource, :receiver, :creator

  belongs_to :media_resource

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  belongs_to :receiver,
             :class_name  => 'User',
             :foreign_key => :receiver_id

  validates :creator,        :presence => true
  validates :media_resource, :presence => true

  class DuplicateShareNotAllowed < Exception; end

  module UserMethods
    def self.included(base)
      base.has_many :received_media_shares,
                    :class_name  => 'MediaShare',
                    :foreign_key => :receiver_id

      base.has_many :sent_media_shares,
                    :class_name  => 'MediaShare',
                    :foreign_key => :creator_id

      base.class_eval do
        scope :receivers_of_shared_resource,
              lambda {|resource|
                joins(:received_media_shares)
                  .where('media_shares.media_resource_id = ? and ' +
                         'media_shares.receiver_id = users.id',
                         resource.id)
              }

        scope :received_media_sharers_with_receiver,
              lambda {|receiver|
                joins(:sent_media_shares)
                  .where('media_shares.receiver_id', receiver.id).uniq
              }
      end

      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def shared_media_resources
        MediaResource.from_sharer(self)
      end

      def received_media_resources
        MediaResource.to_receiver(self)
      end

      def shared_media_resources_to_receiver(receiver)
        MediaResource.from_sharer(self).to_receiver(receiver)
      end

      def received_media_resources_from_sharer(sharer)
        MediaResource.to_receiver(self).from_sharer(sharer)
      end

      def received_media_sharers
        User.received_media_sharers_with_receiver(self)
      end
    end
  end

  module MediaResourceMethods
    def self.included(base)
      base.has_many :media_shares

      base.class_eval do
        scope :from_sharer,
              lambda {|user| where(:creator_id => user.id).uniq}

        scope :to_receiver,
              lambda {|user|
                joins(:media_shares)
                  .where('media_shares.receiver_id = ? and ' +
                         'media_shares.media_resource_id = media_resources.id',
                         user.id)
              }
      end

      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def share_to(receiver)
        relation = receiver.received_media_shares
        raise DuplicateShareNotAllowed.new if relation.where(:media_resource_id => self.id).present?
        relation.create :media_resource => self, :creator => self.creator
      end

      def shared_receivers
        User.receivers_of_shared_resource(self)
      end
    end
  end
end
