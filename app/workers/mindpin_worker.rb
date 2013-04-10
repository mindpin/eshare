module  MindpinWorker
  def self.included(base)
    base.send :include, Sidekiq::Worker
    base.send :extend,  ClassMethods
  end

  module ClassMethods
    def sidekiq_running?
      `ps aux | grep sidekiq`.split("\n").select {|process| process.include? 'busy'}.present?
    end
  end
end
