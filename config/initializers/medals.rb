MEDALS = {
  :PASS_1_CODING_LESSON => {
    :name => '编程新手',
    :desc => '成功完成一个编程教学小节下的所有练习',
  },

  :PASS_1_CODING_STEP => {
    :name => '旅途的第一步',
    :desc => '成功完成一个编程教学练习'
  },

  :PASS_10_CODING_STEP => {
    :name => '十步之泽，必有香草',
    :desc => '成功完成十个编程教学练习'
  },

  :PASS_25_CODING_STEP => {
    :name => '二十五块路牌',
    :desc => '成功完成二十五个编程教学练习'
  },

  :PASS_50_CODING_STEP => {
    :name => '五十个硬币',
    :desc => '成功完成五十个编程教学练习'
  },

  :PASS_100_CODING_STEP => {
    :name => '一百个脚印',
    :desc => '成功完成一百个编程教学练习'
  },

  :ERROR_1_CODING_STEP => {
    :name => '错误总是难免的',
    :desc => '在一个编程教学练习中出错'
  },

  :ERROR_10_CODING_STEP => {
    :name => '不要气馁',
    :desc => '在十个编程教学练习中出错'
  },

  :ERROR_25_CODING_STEP => {
    :name => '有失才有得',
    :desc => '在二十五个编程教学练习中出错'
  },

  :ERROR_50_CODING_STEP => {
    :name => '坚持不懈',
    :desc => '在五十个编程教学练习中出错'
  },

  :ERROR_100_CODING_STEP => {
    :name => '百战不殆',
    :desc => '在一百个编程教学练习中出错'
  },
}

class Medal
  class UserMedal < ActiveRecord::Base
    after_create :send_faye_message

    def send_faye_message
      hash = {
        :type => 'got_medal',
        :name => self.medal.name,
        :medal_name => self.medal_name
      }

      FayeClient.publish "/users/#{self.user_id}/medal", hash
    end
  end
end