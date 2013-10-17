require "spec_helper"

describe KnowledgeQuestionNote do

  describe "create(hash)" do

    before {
      @knowledge_question     = FactoryGirl.create :knowledge_question
      @user         = FactoryGirl.create :user

      @content = 'test content'
      @code_type = 'javascript'
      note_hash = {:creator => @user, :content => @content, :code_type => @code_type}
      @knowledge_question_note = @knowledge_question.knowledge_question_notes.create(note_hash)
    }

    describe "invalid note_hash" do
      it "empty content, image, code" do
        note_hash = {:creator => @user, :code_type => @code_type}
        @note = @knowledge_question.knowledge_question_notes.create(note_hash)
        @note.id.blank?.should == true
      end

      it "empty image, code" do
        note_hash = {:creator => @user, :content => @content, :code_type => @code_type}
        @note = @knowledge_question.knowledge_question_notes.create(note_hash)
        @note.id.blank?.should == false
      end

      it "empty content, code" do
        note_hash = {:creator => @user, :image => 'test image', :code_type => @code_type}
        @note = @knowledge_question.knowledge_question_notes.create(note_hash)
        @note.id.blank?.should == false
      end

      it "empty content, image" do
        note_hash = {:creator => @user, :code => 'test code', :code_type => @code_type}
        @note = @knowledge_question.knowledge_question_notes.create(note_hash)
        @note.id.blank?.should == false
      end
    end

    it "knowledge_question_note knowledge_question" do
      @knowledge_question_note.knowledge_question.should == @knowledge_question
    end

    it "knowledge_question_note creator" do
      @knowledge_question_note.creator.should == @user
    end

    it "knowledge_question_note content" do
      @knowledge_question_note.content.should == @content
    end

    it "knowledge_question_note code_type" do
      @knowledge_question_note.code_type.should == @code_type
    end

    it "knowledge_question_note image" do
      @knowledge_question_note.image.should == nil
    end

    it "knowledge_question_note code" do
      @knowledge_question_note.code.should == nil
    end

  end

  describe "by_creator(user)" do
    before {
      @knowledge_question     = FactoryGirl.create :knowledge_question
      @user_1         = FactoryGirl.create :user
      @user_2         = FactoryGirl.create :user
      @content = 'test content'

      @note_1 = FactoryGirl.create :knowledge_question_note,
                                    :knowledge_question => @knowledge_question,
                                    :creator => @user_1,
                                    :content => @content
      
      @note_2 = FactoryGirl.create :knowledge_question_note,
                                    :knowledge_question => @knowledge_question,
                                    :creator => @user_1,
                                    :content => @content

      @note_3 = FactoryGirl.create :knowledge_question_note,
                                    :knowledge_question => @knowledge_question,
                                    :creator => @user_2,
                                    :content => @content                 
    }

    it "user_1 notes" do
      notes = @knowledge_question.knowledge_question_notes.by_creator(@user_1)
      notes.should == [@note_1, @note_2]
    end

    it "user_2 notes" do
      notes = @knowledge_question.knowledge_question_notes.by_creator(@user_2)
      notes.should == [@note_3]
    end

  end


  describe "by_knowledge_net(knowledge_net)" do
    before {

      @user_1         = FactoryGirl.create :user
      @user_2         = FactoryGirl.create :user
      @knowledge_net_id = 'test id'
      @knowledge_net = Struct.new(:id).new(@knowledge_net_id)

      @knowledge_node_record  = FactoryGirl.create :knowledge_node_record, 
                                                  :knowledge_net_id => @knowledge_net_id


      @knowledge_question  = FactoryGirl.create :knowledge_question, 
                            :knowledge_node_id => @knowledge_node_record.knowledge_node_id

      @knowledge_question_2  = FactoryGirl.create :knowledge_question


      @content = 'test content'
      @code_type = 'javascript'

      note_hash = {:creator => @user_1, :content => @content, :code_type => @code_type}
      @note_1 = @knowledge_question.knowledge_question_notes.create(note_hash)
      @note_2 = @knowledge_question.knowledge_question_notes.create(note_hash)
      @note_3 = @knowledge_question_2.knowledge_question_notes.create(note_hash)

      note_hash = {:creator => @user_2, :content => @content, :code_type => @code_type}
      @note_4 = @knowledge_question.knowledge_question_notes.create(note_hash)
      @note_5 = @knowledge_question.knowledge_question_notes.create(note_hash)
    }

    it "user_1 notes by knowledge_net" do
      notes = @user_1.knowledge_question_notes.by_knowledge_net(@knowledge_net)
      notes.should == [@note_1, @note_2]
    end

    it "user_2 notes by knowledge_net" do
      notes = @user_2.knowledge_question_notes.by_knowledge_net(@knowledge_net)
      notes.should == [@note_4, @note_5]
    end

  end

  
end