module MovePosition

  module ModelMethods
    def self.included(base)
      base.send(:default_scope, :order => "position ASC") 
      base.send(:after_create, :set_position)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def set_position
        self.position = self.id
        self.save
      end

      def move_down
        next_record = self.next
        return nil if next_record.nil?

        pos = self.position
        self.position = next_record.position
        self.save!
        
        next_record.position = pos
        next_record.save!
        
        self
      end

      def move_up
        prev_record = self.prev
        return nil if prev_record.nil?

        pos = self.position
        self.position = prev_record.position
        self.save!
        
        prev_record.position = pos
        prev_record.save!

        self
      end

    end

  end

end