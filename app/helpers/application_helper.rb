module ApplicationHelper
  def test_xxx(&block)
    user = User.first

    tmp = capture do
      block.call user
    end
    capture do
      haml_tag :div, :class => 'haha' do
        concat 'haha'
      end
    end
  end
end
