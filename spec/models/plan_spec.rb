require "spec_helper"

describe Plan do
  let(:plan) {FactoryGirl.create :plan}
  let(:user) {plan.creator}
  let(:net)  {obj = double;obj.stub(:id) {"n04"};obj}

  specify {user.plans.with_knowledge_net(net).size.should be 1}
  specify {plan.course.should be_present}
end
