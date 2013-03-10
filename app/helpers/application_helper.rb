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

  include SimpleImages

end
