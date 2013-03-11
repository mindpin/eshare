module ApplicationHelper

  module SimpleImages
    class ImageRender
      def initialize(view, src, options = {})
        @view   = view
        @src    = src
        @alt    = options[:alt] || ''
        @width  = options[:width]
        @height = options[:height]
        @meta   = options[:meta] || ''

        @option_class = options[:class]
      end

      def style
        _size_value('width', @width) + _size_value('height', @height)
      end

      def wallpaper_style
        'position:fixed;width:100%;height:100%;top:0;left:0;z-index:-100;'
      end

      def css_class
        ['page-fit-image', 'auto-load', @option_class].compact.join ' '
      end

      def render_fit_image
        @view.content_tag :div, '', 
                          :class => self.css_class, 
                          :style => self.style,
                          :data => {
                            :src  => @src,
                            :alt  => @alt,
                            :meta => @meta
                          }
      end

      def render_wallpaper
        @view.content_tag :div, '', 
                          :class => self.css_class, 
                          :style => self.wallpaper_style,
                          :data => {
                            :src  => @src,
                            :alt  => @alt,
                            :meta => @meta
                          }
      end

      private
        def _size_value(name, v)
          return '' if v.blank?

          value = v.to_s.match(/%/) ? v : "#{v}px"
          "#{name}:#{value};"
        end
    end

    def fit_image(src, options = {})
      ImageRender.new(self, src, options).render_fit_image
    end

    def page_wallpaper(src, options = {})
      ImageRender.new(self, src, options).render_wallpaper
    end
  end

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

  include SimpleImages
  include SimplePageCompoents
end
