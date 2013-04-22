class MediaShare < ActiveRecord::Base
  attr_accessible :media_resource, :receiver

  belongs_to :media_resource
  belongs_to :receiver,
             :class_name  => 'User',
             :foreign_key => :receiver_id

  class DuplicateShareNotAllowed < Exception; end

  module UserMethods
    def self.included(base)
      base.has_many :media_shares,
                    :foreign_key => :receiver_id
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def shared_media_resources
        MediaResource.shared_from(self)
      end

      def received_media_resources
        MediaResource.shared_to(self)
      end

      def shared_media_resources_with_receiver(receiver)
        MediaResource.shared_from(self).shared_to(receiver)
      end

      def received_media_resources_with_sharer(sharer)
        MediaResource.shared_to(self).shared_from(sharer)
      end
    end
  end

  module MediaResourceMethods
    def self.included(base)
      base.has_many :media_shares
      base.class_eval do
        scope :shared_from,
              lambda {|user|
                joins(:media_shares)
                  .where('media_resources.creator_id = ? and ' +
                         'media_shares.media_resource_id = media_resources.id',
                         user.id)
                  .select('distinct(media_resources.id)')
              }

        scope :shared_to,
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
        relation = receiver.media_shares
        raise DuplicateShareNotAllowed.new if relation.where(:media_resource_id => self.id).present?
        relation.create :media_resource => self
      end

      def shared_receivers
        User.joins(:media_shares)
            .where('media_shares.media_resource_id = ? and ' +
                   'media_shares.receiver_id = users.id',
                   self.id)
      end
    end
  end
end
