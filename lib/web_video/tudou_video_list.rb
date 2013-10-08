# -*- coding: utf-8 -*-
require 'open-uri'

class TudouVideoList
  class Importer
    attr_reader :course, :list

    def initialize(url)
      @list = List.new(url)
    end

    def import
      list.items.each do |item|
        ware = chapter.course_wares.new(:title   => item.title,
                                        :creator => chapter.creator,
                                        :url     => item.url)
        ware.kind = 'tudou'
        ware.cover_url_cache = item.pic_url
        ware.save
      end

      course.set_video_course_cover
    end

    def chapter
      @chapter ||= course.chapters.create(:title   => "默认章节",
                                          :creator => course.creator)
    end

    def course
      @course ||= Course.create(:name    => list.title,
                                :cid     => randstr,
                                :with_chapter => false,
                                :creator => User.first)
    end
  end

  class Item
    attr_reader :meta

    def initialize(meta)
      @meta = meta
      define_methods
    end

    def desc
      # @desc ||= JSON.parse(desc_json)["message"]["description"]
      # 0718 性能过低。暂时先不使用
    end
    
    def url
      "http://www.tudou.com/programs/view/#{code}/"
    end

    def pic_url
      self.picUrl
    end

    private
      def desc_json
        @desc_json ||= begin
          url = "http://www.tudou.com/playlist/service/getItemDetail.html?code=#{code}"
          open(url).read
        end
      end

      def define_methods
        meta.each do |key, value|
          define_singleton_method key.underscore do
            meta[key]
          end
        end
      end
  end

  class List
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def response
      @response ||= open(@url).read
    end

    def response_xml
      @response_xml ||= Nokogiri::XML(response)
    end

    def title
      @title ||= response_xml.at_css('.sec_2 .caption').content
      # 10月8日，土豆页面结构更改，宋亮 fix
    end

    def lid
      @lid ||= response.match(/var\slid\s=\s'(\d*)';/)[1].to_i
    end

    def count
      @count ||= response_xml.css('.mod_box_bd .summary.fix')[1].css('i')[0].content.to_i
      # 10月8日，土豆页面结构更改，宋亮 fix
    end

    def items
      @items ||= list_json['message']['items'].map do |meta|
        Item.new(meta)
      end
    end

    private

      def list_json
        @list_json ||= JSON.parse open(list_json_url).read
      end

      def list_json_url
        "http://www.tudou.com/plcover/coverPage/getIndexItems.html?lid=#{lid}&pageSize=#{count}"
      end
  end

  def initialize(url)
    @url = url
    # url like
    # http://www.tudou.com/plcover/M9ovmjs6fkw/
  end

  def parse
    list = List.new(@url)

    title = list.title

    videos = list.items.map {|item|
      { :title => item.title, :url => item.url }
    }

    return {
      :name => title,
      :videos => videos
    }
  end

  module CourseMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def import_tudou_video_list(url, user)
        TudouVideoList::Importer.new(url).import
      end
    end
  end

end
