require 'test_helper'

class FileBreadcrumbCellTest < Cell::TestCase
  test "display" do
    invoke :display
    assert_select "p"
  end
  

end
