class SearchController < ApplicationController
  def search
    @query = query = params[:query]
    @search = Course.search {
      fulltext query
    }
  end
end