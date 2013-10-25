require 'spec_helper'

describe EnvironmentConfigState do
  describe "course_ware 相关 environment_config_state 方法" do
    before {
      @course_ware = FactoryGirl.create(:course_ware)

      @state = FactoryGirl.create(:environment_config_state)
      @state_1 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)
      @state_2 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)

      @state_3_parent_1 = FactoryGirl.create(:environment_config_state, 
                                              :course_ware => @course_ware)
      @state_3_parent_2 = FactoryGirl.create(:environment_config_state, 
                                              :course_ware => @course_ware)
      @state_3_child_1 = FactoryGirl.create(:environment_config_state, 
                                              :course_ware => @course_ware)
      @state_3_child_2 = FactoryGirl.create(:environment_config_state, 
                                              :course_ware => @course_ware)

      @state_3 = FactoryGirl.create(:environment_config_state, :course_ware => @course_ware)
      FactoryGirl.create(:environment_config_state_relation, 
                          :parent_state => @state_3_parent_1, :child_state => @state_3_child_1)
      FactoryGirl.create(:environment_config_state_relation, 
                          :parent_state => @state_3_parent_2, :child_state => @state_3_child_2)
    }

    it "course_ware.environment_config_states" do
      @course_ware.environment_config_states.should == [
        @state_1, 
        @state_2, 
        @state_3_parent_1, 
        @state_3_parent_2, 
        @state_3_child_1, 
        @state_3_child_2
      ]
    end

    it "course_ware.root_environment_config_states" do
      @course_ware.root_environment_config_states.should == [@state_1, @state_2]
    end

    it "所有前置 state" do
      @state_3.parent_states.should == [@state_3_parent_1, @state_3_parent_2]
    end

    it "所有后续 state" do
      @state_3.child_states.should == [@state_3_child_1, @state_3_child_2]
    end

  end

end