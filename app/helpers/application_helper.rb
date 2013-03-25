module ApplicationHelper
  def truncate_u(text, length = 30, truncate_string = "...")
    truncate(text, :length => length, :separator => truncate_string)
  end
end
