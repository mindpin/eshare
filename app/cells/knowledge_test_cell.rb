class KnowledgeTestCell < Cell::Rails
  helper :application

  def notes(opts = {})
    @notes = opts[:notes]
    render
  end
end