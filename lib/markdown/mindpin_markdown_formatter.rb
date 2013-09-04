class MindpinMarkdownFormatter

  def initialize(raw_text)
    @raw_text = raw_text
  end

  def format
    toc  = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC).render(@raw_text)
    html = _build_markdown.render(@raw_text)
    "#{toc}#{html}".html_safe
  end

  private
    def _build_markdown
      render = HTMLwithCoderay.new(
        :filter_html     => true, # 滤掉自定义html
        :safe_links_only => true, # 只允许安全连接
        :hard_wrap       => true, # 单回车换行
        :with_toc_data   => true
      )

      Redcarpet::Markdown.new(render,
        :no_intra_emphasis   => true,
        :fenced_code_blocks  => true,
        :autolink            => true,
        :strikethrough       => true,
        :space_after_headers => true
      )
    end

  # --------

  class HTMLwithCoderay < Redcarpet::Render::HTML
    # 每次渲染正文前必须调用该函数，给一些实例变量赋值
    def initialize(*params)
      super(*params)
    end

    # ---------------

    def block_code(code, language)
      # 代码格式化选项参考
      # http://coderay.rubychan.de/doc/classes/CodeRay/Encoders/HTML.html

      CodeRay.scan(code, language).div(
        :tab_width    => 2,
        :css          => :class,
        :line_numbers => :inline,
        :line_number_anchors => false,
        :bold_every   => false
      )
    end

    # TODO 这里还可以做更多扩展
    # TODO 参考这个： 
    #   http://dev.af83.com/2012/02/27/howto-extend-the-redcarpet2-markdown-lib.html
    #   "How to extend the Redcarpet 2 Markdown library?"
  end

end