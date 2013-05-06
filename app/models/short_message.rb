class ShortMessage < ActiveRecord::Base
  attr_accessible :sender, :receiver, :content, :receiver_read, :sender_hide, :receiver_hide

  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :receiver_id

  validates :sender, :receiver, :content, :presence => true


  def receiver_read!
    self.receiver_read = true
    self.save
    self.reload
  end


  module UserMethods
    def self.included(base)
    end

    def send_message(content, receiver)
      ShortMessage.create(
        :sender => self,
        :receiver => receiver,
        :content => content,
        :receiver_read => false,
        :receiver_hide => false,
        :sender_hide => false
      )

    end

    def inbox
      sql = %~
        select id, MY_ID, CONTACT_ID, content, receiver_read, sender_hide, 
        receiver_hide, created_at, updated_at from (
          (
            SELECT id, sender_id AS MY_ID, receiver_id AS CONTACT_ID, content, receiver_read,  
            sender_hide, receiver_hide, created_at, updated_at 
            FROM short_messages
            WHERE sender_id = #{self.id} and sender_hide = false
          ) 

          union

          (
            SELECT id, receiver_id AS MY_ID, sender_id AS CONTACT_ID, content, receiver_read,
            sender_hide, receiver_hide, created_at, updated_at 
            FROM short_messages
            WHERE receiver_id = #{self.id} and receiver_hide = false
          ) 
          
        ) as T
        group by T.MY_ID, T.CONTACT_ID
        order by id desc
      ~

      ShortMessage.find_by_sql(sql)
    end

    def short_messages_of_user(user)
      ShortMessage.where(:sender_id => user.id, :receiver_id => self.id, :receiver_hide => false)
    end

    def remove_short_message(message)
      message = ShortMessage.find(message.id)
      return false if message.blank?

      message.sender_hide = true if message.sender == self
      message.receiver_hide = true  if message.receiver == self
      
      message.save
      message.reload

    end


  end


end

