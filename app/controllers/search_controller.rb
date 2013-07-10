class SearchController < ApplicationController
  before_filter :authenticate_user!

  layout Proc.new { |controller|
    return 'grid'
  }

  def search
    @query = query = params[:query]
    @course_search = Course.search {
      fulltext query
    }
    @question_search = Question.search {
      fulltext query
    }
  end
end