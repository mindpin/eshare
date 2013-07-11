class Medal::UserMedal < ActiveRecord::Base
  after_create :send_faye_message
  def send_faye_message
    hash = {
      :type => 'got_medal',
      :medal_name => self.medal_name
    }

    FayeClient.publish "/users/#{self.user_id}", hash
  end
end