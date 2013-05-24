class QuestionsCell < Cell::Rails
  helper :application

  def list(opts = {})
    @user = opts[:user]
    @questions = opts[:questions]
    render
  end
end