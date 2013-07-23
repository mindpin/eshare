class Report < ActiveRecord::Base
  CONFIRM = 'CONFIRM'
  REJECT  = 'REJECT'
  UNPROCESSED = 'UNPROCESSED'


  attr_accessible :user, 
                  :report_user, 
                  :desc, 
                  :model,
                  :status,
                  :admin_reply
  
  belongs_to :user
  belongs_to :report_user, :class_name => 'User'
  belongs_to :model, :polymorphic => true

  validates  :status, :inclusion  => [CONFIRM, REJECT, UNPROCESSED]
  validates  :report_user_id,:desc,:model_id,:model_type,:status,
             :presence => true

  scope :confirmed,   :conditions => ['reports.status = ?', CONFIRM]
  scope :rejected,    :conditions => ['reports.status = ?', REJECT]
  scope :unprocessed, :conditions => ['reports.status = ?', UNPROCESSED]

  module UserMethods
    def self.included(base) 
      base.has_many :reports, :as => :model 
    end

    def report(model,desc) #question,answer,user等
      Report.create(
                    :user => self, 
                    :report_user => _report_user(model),
                    :model => model, 
                    :desc => desc,
                    :status => UNPROCESSED
                   )
    end

    private
      def _report_user(model)
        if model.is_a? User
          report_user = model
        elsif model.respond_to?(:creator)
          report_user = model.creator
        elsif model.respond_to?(:user)
          report_user = model.user
        end
        report_user
      end
  end           
  # 管理员审核举报成功
  def confirm(admin_reply)
    self.update_attributes(:status => 'CONFIRM', :admin_reply => admin_reply)
  end
  # 管理员驳回举报
  def reject(admin_reply)
    self.update_attributes(:status => 'REJECT', :admin_reply => admin_reply)                 
  end                 
end