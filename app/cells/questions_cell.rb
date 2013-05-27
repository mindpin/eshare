class QuestionsCell < Cell::Rails
  helper :application

  def list(opts = {})
    @user = opts[:user]
    @questions = opts[:questions]
    render
  end

  def tree(opts = {})
    @user = opts[:user]
    @question = opts[:question]
    render
  end

  def info(opts = {})
    @question = opts[:question]
    render
  end

  def linked_course(opts = {})
    @user = opts[:user]
    @question = opts[:question]
    @course = @question.course
    render
  end
end