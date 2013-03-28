class Tagging < ActiveRecord::Base
  attr_accessible :tag, :taggable, :user

  belongs_to :user
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

  validates :tag, :taggable, :presence => true

  scope :have_user, :conditions => 'user_id is not null'
  scope :by_user, lambda { | user | {:conditions => "user_id = #{user.id}"} }
  scope :by_tag,  lambda { |  tag | {:conditions => "tag_id = #{tag.id}"} }
  scope :by_tags, lambda { | tags | {:conditions => "tag_id in (#{tags.map(&:id)*','})"} }

  after_save :update_public_tags
  after_destroy :update_public_tags
  def update_public_tags
    return if self.user_id.blank?

    count  = taggable.private_tagged_count(tag)
    tagged = taggable.tagged_with_creator?(tag)

    if tagged || count > 1
      taggable.send(:_add_public_tag, self.tag)
      return
    end

    if !tagged && count < 2
      taggable.send(:_remove_public_tag, self.tag)
      return
    end
  end

  module TaggableMethods
    extend ActiveSupport::Concern

    included do
      self.has_many :taggings, :as => :taggable
      self.has_many :public_tags, :through => :taggings,
        :source => :tag,
        :conditions => 'taggings.user_id is null'
    end

    def private_tags(user)
      Tag.joins(:taggings).where(:taggings => {
        :user_id       => user.id,
        :taggable_type => self.class.name,
        :taggable_id   => self.id
      })
    end

    def set_tag_list(str, options = {})
      user = options[:user] || self.creator
      after_tags = _get_by_str(str)

      _set_private_tags(after_tags, user)

      after_tags
    end

    def private_tagged_count(tag)
      self.taggings.by_tag(tag).have_user.count
    end

    def tagged_with_creator?(tag)
      self.taggings.by_tag(tag).by_user(self.creator).present?
    end

    private

      def _add_public_tag(tag)
        return if self.public_tags.include?(tag)
        self.taggings.create(:tag => tag)
      end

      def _remove_public_tag(tag)
        return if !self.public_tags.include?(tag)
        self.taggings.by_tag(tag).destroy_all
      end

      def _set_private_tags(after_tags, user)
        before_tags  = self.private_tags(user)
        removed_tags = before_tags - after_tags
        added_tags   = after_tags  - before_tags

        if removed_tags.present?
          self.taggings.by_user(user).by_tags(removed_tags).destroy_all
        end

        added_tags.each do |tag|
          self.taggings.create(:tag => tag, :user => user)
        end
      end

      def _get_by_str(str)
        tag_names = str.downcase.split(/\s|,|，/).compact.uniq
        tag_names.map do |name|
          Tag.find_or_create_by_name(name)
        end
      end

    module ClassMethods
      def by_tag(tag_name, options = {})
        tag = Tag.by_name(tag_name).first
        return [] if tag.blank?

        user = options[:user]
        user_id_params = user.blank? ? nil : [nil, user.id]

        self.joins(:taggings).where(:taggings => {
          :user_id => user_id_params,
          :tag_id  => tag.id
        })

      end
    end

  end
end