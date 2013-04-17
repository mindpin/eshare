module MovePosition
  


  module ModelMethods
    def self.included(base)
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def prev   
        self.class.last(:conditions => ['position < ?', self.position])
      end

      def next
        self.class.first(:conditions => ['position > ?', self.position])
      end

  
      def move_down
        next_record = self.next
        return nil if next_record.nil?

        position = self.position
        self.position = next_record.position
        self.save
        
        next_record.position = position
        next_record.save
        
        self
      end

      def move_up
        prev_record = self.prev
        return nil if prev_record.nil?

        position = self.position
        self.position = prev_record.position
        self.save
        
        prev_record.position = position
        prev_record.save

        self
      end

    end

  end

end