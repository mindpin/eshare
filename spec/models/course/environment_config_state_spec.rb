require 'spec_helper'

describe EnvironmentConfigState do
  describe "course_ware 相关 environment_config_state 方法" do
    before {
      @course_ware = FactoryGirl.create(:course_ware)

      @state = FactoryGirl.create(:environment_config_state)
      @state_1 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)
      @state_2 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)
      @state_3 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)
      @state_4 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)
      @state_5 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)
      @state_6 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)

      FactoryGirl.create(:environment_config_state_relation, 
                          :parent_state => @state_1, :child_state => @state_4)
      FactoryGirl.create(:environment_config_state_relation, 
                          :parent_state => @state_2, :child_state => @state_4)
      FactoryGirl.create(:environment_config_state_relation, 
                          :parent_state => @state_3, :child_state => @state_4)

      FactoryGirl.create(:environment_config_state_relation, 
                          :parent_state => @state_4, :child_state => @state_5)
      FactoryGirl.create(:environment_config_state_relation, 
                          :parent_state => @state_4, :child_state => @state_6)
    }

    it "course_ware.environment_config_states" do
      @course_ware.environment_config_states.should == [
        @state_1, 
        @state_2, 
        @state_3, 
        @state_4, 
        @state_5, 
        @state_6
      ]
    end

    it "course_ware.root_environment_config_states" do
      @course_ware.root_environment_config_states.should == [@state_1, @state_2, @state_3]
    end

    it "state_4 所有前置 state" do
      @state_4.parent_states.should == [@state_1, @state_2, @state_3]
    end

    it "state_4 所有后续 state" do
      @state_4.child_states.should == [@state_5, @state_6]
    end

    it "state_1 所有后续 state" do
      @state_1.child_states.should == [@state_4]
    end

    it "state_2 所有后续 state" do
      @state_2.child_states.should == [@state_4]
    end

    it "state_3 所有后续 state" do
      @state_3.child_states.should == [@state_4]
    end

  end

end