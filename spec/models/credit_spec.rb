# -*- coding: utf-8 -*-
require "spec_helper"

describe Question do
  let(:user_A)   {FactoryGirl.create :user}
  let(:user_B)   {FactoryGirl.create :user}

  shared_examples "vote" do |model, direction, delta, options={}|
    cond = options[:zero] ? " if A's credit is 0" : nil

    it "B votes #{direction} A's #{model}#{cond}" do
      value = options[:zero] ? 0 : 100
      user_A.add_credit(value, :ho, subject)

      expect {
        subject.send "vote_#{direction}_by!", user_B
      }.to change {user_A.credit_value}.by(delta)
    end
  end

  context "question vote" do
    subject {FactoryGirl.create :question, :creator => user_A}

    it_should_behave_like("vote", :question, :up, 5)
    it_should_behave_like("vote", :question, :down, -2)
    it_should_behave_like("vote", :question, :down, 0, :zero => true)
  end

  context "answer vote" do
    subject {FactoryGirl.create :answer, :creator => user_A}
    
    it_should_behave_like("vote", :answer, :up, 10)
    it_should_behave_like("vote", :answer, :down, -1)
    it_should_behave_like("vote", :answer, :down, 0, :zero => true)
  end
end
