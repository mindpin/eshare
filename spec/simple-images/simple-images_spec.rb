require 'spec_helper'

include ApplicationHelper::SimpleImages

describe ImageRender do
  let(:view) {stub(:view)}
  let(:src) {'http://foo.com/bar.jpg'}

  describe '#style' do
    it {  
      render = ImageRender.new(view, src, :width => 100, :height => 100)
      render.style.should == 'width:100px;height:100px;'
    }

    it {  
      render = ImageRender.new(view, src, :width => 100)
      render.style.should == 'width:100px;'
    }

    it {  
      render = ImageRender.new(view, src, :height => 100)
      render.style.should == 'height:100px;'
    }

    it {  
      render = ImageRender.new(view, src)
      render.style.should == ''
    }

    it {  
      render = ImageRender.new(view, src, :width => '80%', :height => '40%')
      render.style.should == 'width:80%;height:40%;'
    }

    it {  
      render = ImageRender.new(view, src, :height => '40%')
      render.style.should == 'height:40%;'
    }
  end

  describe '#css_class' do
    it {  
      render = ImageRender.new(view, src, :class => 'flower red')
      render.css_class.should == 'page-fit-image auto-load flower red'
    }

    it {  
      render = ImageRender.new(view, src, :class => 'flower')
      render.css_class.should == 'page-fit-image auto-load flower'
    }

    it {  
      render = ImageRender.new(view, src)
      render.css_class.should == 'page-fit-image auto-load'
    }
  end
end