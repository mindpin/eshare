# -*- coding: utf-8 -*-
require 'open-uri'

class YoukuVideoList
  def initialize(url)
    @url = url

    # url like
    # page_url http://www.youku.com/show_page/id_zbd8216202dfa11e2b2ac.html
    # point_url http://www.youku.com/show_point_id_zbd8216202dfa11e2b2ac.html?dt=json&__rt=1&__ro=reload_point
    # tab_url http://www.youku.com/show_point/id_zbd8216202dfa11e2b2ac.html?dt=json&divid=point_reload_201305&tab=0&__rt=1&__ro=point_reload_201305
  end

  def video_list_id
    @url.split('id_')[1].split('.')[0]
  end

  def show_point_url
    "http://www.youku.com/show_point_id_#{video_list_id}.html?dt=json&__rt=1&__ro=reload_point"
  end

  def get_tab_urls
    tab_urls = []
    doc = Nokogiri::XML(open(show_point_url), nil, 'utf-8')

    tabs = doc.css('#zySeriesTab li')
    if tabs.blank?
      return [show_point_url]
    end

    tabs.map do |el|
      tab = el.attributes['data'].value
      tab_urls << "http://www.youku.com/show_point/id_#{video_list_id}.html?dt=json&divid=#{tab}&tab=0&__rt=1&__ro=#{tab}"
    end

    tab_urls
  end

  def parse
    chapters = []

    doc_0 = Nokogiri::XML(open(@url), nil, 'utf-8')
    course_name = doc_0.at_css('.base .title .name').content.strip
    course_desc = doc_0.at_css('.aspect_con .detail').content.strip

    get_tab_urls.each do |tab_url|
      doc = Nokogiri::XML(open(tab_url), nil, 'utf-8')

      c = doc.css('.item .title a').map { |el|
        attr_title = el.attributes['title']
        attr_href = el.attributes['href']

        next if attr_title.nil? || attr_href.nil?

        title = attr_title.value
        url = attr_href.value

        { :title => title, :url => url }
      }

      chapters += c
    end
    chapters.delete_if {|x| x == nil}

    return { :name => course_name, :desc => course_desc, :chapters => chapters }

  end

  module CourseMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def import_youku_video_list(url, user)
        data = YoukuVideoList.new(url).parse

        course = Course.create(
          :name => data[:name],
          :desc => data[:desc],
          :cid => randstr,
          :creator => user,
          :with_chapter => false
        )

        chapter = Chapter.create(
          :title => "默认章节",
          :creator => user,
          :course => course
        )

        data[:chapters].each do |ch|
          chapter.course_wares.create(
            {
              :title => ch[:title],
              :desc => '',
              :url => ch[:url],
              :kind => 'youku',
              :creator => user
            }, { :as => :import }
          )
        end

        course.set_video_course_cover
        course
      end
    end
  end
end
