class DynamicAttr < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  class TypeMismatch < Exception;end

  module Owner
    def self.included(base)
      base.send :extend,   ClassMethods
    end

    module Helper
      class << self
        def _to_string(str)
          str.to_s
        end

        def _to_datetime(str)
          str.to_datetime
        end

        def _to_boolean(str)
          {true: true, false: false}[str.to_sym]
        end

        def _to_integer(str)
          str.to_i
        end
      end
    end

    module ClassMethods

      def has_dynamic_attrs(name, fields: Hash.new)
        has_many :dynamic_attrs, as: :owner, conditions: {:name => name}

        define_method "_#{name}_type_match" do
          fields.inject({}) do |hash, (field, type)|
            hash[field] = {string: String, datetime: DateTime, boolean: [TrueClass, FalseClass], integer: Integer}[type]
            hash
          end
        end

        define_method "_#{name}_type_valid?" do |field, value|
          type = send("_#{name}_type_match")[field]
          type.is_a?(Array) ? type.include?(value.class) : value.is_a?(type)
        end

        fields.each do |field, type|
          define_method "#{name}_#{field}=" do |value|
            raise DynamicAttr::TypeMismatch.new if !send("_#{name}_type_valid?", field, value)
            relation = DynamicAttr.where(name: name, owner_type: self.class.to_s, owner_id: self.id, field: field)
            attr = relation.first ? relation.first : relation.new
            attr.update_attribute(:value, value.to_s)
            value 
          end

          define_method "#{name}_#{field}" do
            attr = DynamicAttr.where(name: name, owner_type: self.class.to_s, owner_id: self.id, field: field).first
            return if attr.blank?
            Helper.send "_to_#{type}", attr.value
          end

        end

      end
    end

  end
end
