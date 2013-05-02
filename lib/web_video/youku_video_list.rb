require 'open-uri'

class YoukuVideoList
  def initialize(url)
    @url = url
    # url like
    # http://www.youku.com/show_page/id_z7a3c4ddaaed011e1b52a.html
  end

  def video_list_id
    @url.split('id_')[1].split('.')[0]
  end

  def show_episode_url
    "http://www.youku.com/show_episode/id_#{video_list_id}.html"
  end

  def parse
    doc_0 = Nokogiri::XML(open(@url), nil, 'utf-8')
    course_name = doc_0.at_css('.base .title .name').content.strip
    course_desc = doc_0.at_css('.aspect_con .detail').content.strip

    doc = Nokogiri::XML(open(show_episode_url), nil, 'utf-8')

    chapters = doc.css('li a').map { |el|
      title = el.attributes['title'].value
      url = el.attributes['href'].value
      
      { :title => title, :url => url }
    }

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
          :creator => user
        )

        data[:chapters].each do |ch|
          chapter = Chapter.create(
            :title => ch[:title],
            :creator => user,
            :course => course
          )

          chapter.course_wares.create(
            {
              :title => '视频',
              :desc => '',
              :url => ch[:url],
              :kind => 'youku',
              :creator => user
            }, { :as => :import }
          )
        end

      end
    end
  end
end