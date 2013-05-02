module Tudou
  class Importer
    attr_reader :course, :list

    def initialize(url)
      @list = Tudou::List.new(url)
    end

    def import
      list.items.each do |item|
        chapter = course.chapters.create(:title   => item.title,
                                         :desc    => item.desc,
                                         :creator => course.creator)

        ware = chapter.course_wares.new(:title   => item.title,
                                        :creator => chapter.creator,
                                        :url     => item.url)
        ware.kind = 'tudou'
        ware.save
      end
    end

    def course
      @course ||= Course.create(:name    => list.title,
                                :cid     => list.lid,
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

    def title
      @title ||= Nokogiri::XML(open(url)).css('h1#plCaption')[0].content
    end

    def lid
      @lid ||= open(url).read.match(/var\slid\s=\s'(\d*)';/)[1].to_i
    end

    def items
      @items ||= JSON.parse(list_json)["message"]["items"].map do |meta|
        Item.new(meta)
      end
    end

  private

    def list_json
      @list_json = open(list_json_url).read
    end

    def list_json_url
      "http://www.tudou.com/plcover/coverPage/getIndexItems.html?lid=#{lid}"
    end
  end
end
