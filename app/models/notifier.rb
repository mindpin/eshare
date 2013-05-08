# -*- coding: utf-8 -*-
module Notifier
  def self.included(base)
    base.after_save Sender.new
  end

  class Sender
    attr_reader :model

    def after_save(model)
      @model = model
      FayeClient.publish("/users/#{model.receiver.id}", message)
    end

  private

    def message
      {:type => model.class.to_s.underscore, :count => model.inbox_count}
    end
  end
end
