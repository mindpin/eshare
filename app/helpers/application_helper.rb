module ApplicationHelper

  module SimplePageCompoents
    class NavbarRender
      class NavItem
        attr_accessor :text, :url
        def initialize(text, url)
          @text = text
          @url  = url
        end
      end

      def initialize(view, *args)
        @view = view
        @items = []
        @prepends = []

        @fixed_top = args.include? :fixed_top
        @fixed_bottom = args.include? :fixed_bottom
        @color_inverse =  args.include? :color_inverse
      end

      def add_item(text, url)
        @items << NavItem.new(text, url)
        self
      end

      def prepend(str)
        @prepends << str
      end

      def css_class
        c = ['page-navbar']
        c << 'navbar-fixed-top' if @fixed_top
        c << 'navbar-fixed-bottom' if @fixed_buttom
        c << 'color-inverse' if @color_inverse

        c.join(' ')
      end

      def render
        @view.haml_tag :div, :class => self.css_class do
          @view.haml_tag :div, :class => 'navbar-inner' do
            @view.haml_tag :div, :class => 'nav-prepend' do
              @prepends.each do |p|
                @view.haml_concat p
              end
            end

            @view.haml_tag :ul, :class => 'nav' do
              @items.each do |item|
                @view.haml_tag :li do
                  @view.haml_tag :a, item.text,:href => item.url
                end
              end
            end
          end
        end
      end
    end

    def page_navbar(*args)
      NavbarRender.new(self, *args)
    end
  end

  include SimplePageCompoents
end
