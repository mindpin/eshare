class Youku

  def parse_youku_list(url)
    id  = url.match(/^http:\/\/www\.youku\.com\/show_page\/id_(\w*)\.html$/)[1]
    doc = Nokogiri::XML(open(youku_list_url(id)), nil, 'utf-8')
    chapters = doc.css('li a').map { |el| 
      [el.attributes['title'].value, el.attributes['href'].value]
    }

    doc = Nokogiri::XML(open(url), nil, 'utf-8')

    
    course_desc = doc.css('.aspect_con .detail')[0].content.strip
    course_name = doc.css('.name')[0].content.strip



    {:name => course_name, :desc => course_desc, :chapters => chapters}
  end

  def youku_list_url(id)
    "http://www.youku.com/show_episode/id_#{id}.html"
  end

end



youku_page = ARGV[0]


user = User.first


youku = Youku.new
data = youku.parse_youku_list(youku_page)

while true
  r = Random.new
  cid = r.rand(100...999999999)
  break if !Course.where(:cid => cid).exists?
end


course = Course.create(
  :name => data[:name],
  :desc => data[:desc],
  :cid => cid,
  :creator => user
)

# p course.errors

data[:chapters].each do |c|
  title = c[0]
  url = c[1]
  chapter = Chapter.create(
    :course => course,
    :title => title,
    :creator => user
  )

  ware = chapter.course_wares.create(
    {
    :title => title,
    :desc => '',
    :url => url,
    :kind => 'youku',
    :creator => user
    }, { :as => :import }
  )

  # p ware.errors
end

