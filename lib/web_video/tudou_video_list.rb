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
        ware.save
      end
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
      @desc ||= JSON.parse(desc_json)["message"]["description"]
    end
    
    def url
      "http://www.tudou.com/programs/view/#{code}/"
    end

    private

      def desc_json_url
        "http://www.tudou.com/playlist/service/getItemDetail.html?code=#{code}"
      end

      def desc_json
        @desc_json ||= open(desc_json_url).read
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

    def title
      @title ||= Nokogiri::XML(response).at_css('h1#plCaption').content
    end

    def lid
      @lid ||= response.match(/var\slid\s=\s'(\d*)';/)[1].to_i
    end

    def count
      @count ||= Nokogiri::XML(response).at_css('span.dd').content.to_i
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
    desc = ''

    chapters = list.items.map {|item|
      { :title => item.title, :url => item.url, :desc => item.desc }
    }

    return {
      :name => title,
      :desc => desc,
      :chapters => chapters
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
