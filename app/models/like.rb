class Like < ActiveRecord::Base
  belongs_to :model,
             :polymorphic => true,
             :counter_cache => true

  belongs_to :user

  validates :user_id, :uniqueness => {:scope => [:model_type, :model_id]}

  scope :with_model, ->(model) {where(:model_id => model.id, :model_type => model.class.to_s)}

  module ModelMethods
    def self.included(base)
      base.send :has_many, :likes, :as => :model
    end
  end

  module UserMethods
    def self.included(base)
      base.send :has_many, :likes
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def like(model)
        self.likes.with_model(model).create
      end

      def cancel_like(model)
        record = self.likes.with_model(model).first
        !!record && record.destroy
      end
    end
  end
end
