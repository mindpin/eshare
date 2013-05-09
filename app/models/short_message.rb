# -*- coding: utf-8 -*-
class ShortMessage < ActiveRecord::Base
  attr_accessible :sender, :receiver, :content, :receiver_read, :sender_hide, :receiver_hide

  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :receiver_id

  validates :sender, :receiver, :content, :presence => true

  scope :of_user, lambda { |user1, user2|
    {
      :conditions => [
        %~
          (sender_id = ? AND receiver_id = ? AND sender_hide IS FALSE)
          OR
          (sender_id = ? AND receiver_id = ? AND receiver_hide IS FALSE)
        ~,
        user1.id, user2.id, # 由我发送的消息
        user2.id, user1.id # 由我接收的消息
      ]
    }
  }

  after_save :send_faye_message
  def send_faye_message
    hash = {
      :type => 'short_message',
      :sender => {
        :id => sender.id,
        :name => sender.name
      },
      :content => content
    }

    FayeClient.publish "/users/#{receiver.id}", hash
  end

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
        select T.*, T.MY_ID, T.CONTACT_ID from (
          (
            SELECT t1.*, sender_id AS MY_ID, receiver_id AS CONTACT_ID 
            FROM short_messages as t1
            WHERE sender_id = #{self.id} and sender_hide = false
          ) 

          union

          (
            SELECT t2.*, receiver_id AS MY_ID, sender_id AS CONTACT_ID 
            FROM short_messages as t2
            WHERE receiver_id = #{self.id} and receiver_hide = false
          ) 
          order by id DESC 
        ) as T
        group by T.MY_ID, T.CONTACT_ID
        order by T.id DESC
      ~

      ShortMessage.find_by_sql(sql)

    end

    def short_messages_of_user(user)
      ShortMessage.of_user(self, user).order('id DESC')
    end

    def remove_short_message(message)
      message = ShortMessage.find(message.id)
      return if message.blank?

      message.update_attributes({:sender_hide => true}) if message.sender == self
      message.update_attributes({:receiver_hide => true}) if message.receiver == self
  
      message.reload
      message

    end

  end

end