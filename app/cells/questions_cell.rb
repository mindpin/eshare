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

  def tree_question(opts = {})
    @user = opts[:user]
    @question = opts[:question]
    render
  end

  def tree_answers(opts = {})
    @user = opts[:user]
    @answers = opts[:answers]
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
    return render if @course
    return ''
  end
end