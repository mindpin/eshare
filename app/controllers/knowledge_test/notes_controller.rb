class KnowledgeTest::NotesController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'flat-grid'
  end

  def index
    @question = KnowledgeQuestion.find(params[:question_id])
    @notes = @question.knowledge_question_notes.by_creator(current_user)

    if request.xhr?
      render :json => {
        :status => 'ok',
        :html => (
          render_cell :knowledge_test, :notes, :notes => @notes
        )
      }
    end
  end

  def create
    @question = KnowledgeQuestion.find(params[:question_id])

    @note = @question.knowledge_question_notes.create(
      :creator => current_user,
      :content => params[:text],
      :code_type => 'javascript'
    )

    if request.xhr?
      render :json => {
        :status => 'ok',
        :html => (
          render_cell :knowledge_test, :notes, :notes => [@note]
        )
      }
    end
  end

  def destroy
    @note = KnowledgeQuestionNote.find(params[:id])
    @note.destroy
    if request.xhr?
      render :json => {
        :status => 'ok'
      }
    end
  end

end
