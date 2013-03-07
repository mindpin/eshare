require 'active_support/concern'

module ModelRemovable
  extend ActiveSupport::Concern

  included do
    default_scope   where(:is_removed => false)
    scope :removed, where(:is_removed => true)
  end

  module ClassMethods
    def after_false_remove_callback_array
      self.instance_variable_get(:@after_false_remove) || []
    end

    def add_after_false_remove_callback(sym)
      callbacks = self.instance_variable_get(:@after_false_remove)
      callbacks ||=[]
      callbacks << sym.to_sym
      self.instance_variable_set(:@after_false_remove,callbacks)
    end

    def after_false_remove(sym)
      add_after_false_remove_callback sym.to_sym
    end
  end

  module InstanceMethods
    def remove
      self.update_attribute :is_removed, true
      nullify_unique_attributes
      self.class.after_false_remove_callback_array.each do |sym|
        self.send(sym)
      end
    end

    def recover
      self.update_attribute :is_removed, false
    end

  private

    def unique_attributes
      self.class.validators.select {|validator|
        validator.instance_of? ActiveRecord::Validations::UniquenessValidator
      }.first.attributes
    rescue
      []
    end

    def nullify_unique_attributes
      unique_attributes.each do |attribute|
        self.update_attribute attribute, nil
      end

    end

  end

end
