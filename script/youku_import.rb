class Youku

  def parse_youku_list(url)
    id  = url.match(/^http:\/\/www\.youku\.com\/show_page\/id_(\w*)\.html$/)[1]
    doc = Nokogiri::HTML(open(youku_list_url(id)), nil, 'utf-8')
    chapters = doc.css('li a').map {|el| [el.attributes['title'].value, el.attributes['href'].value] }

    doc = Nokogiri::HTML(open('http://www.youku.com/show_page/id_zb3df4274140a11e1a046.html'), nil, 'utf-8')

    
    course_desc = doc.css('.aspect_con .detail')[0].content.strip
    course_name = doc.css('.name')[0].content.strip

    {:name => course_name, :desc => course_desc, :chapters => chapters}
  end

  def youku_list_url(id)
    "http://www.youku.com/show_episode/id_#{id}.html"
  end

end

=begin
course = Course.find_by_cid(9999999999)
course.chapters.each do |c|
  c.course_wares.destroy_all
  c.destroy
end
course.destroy
=end

# youku_page = 'http://www.youku.com/show_page/id_zb3df4274140a11e1a046.html'
youku_page = ARGV[0]


user = User.first


youku = Youku.new
data = youku.parse_youku_list(youku_page)



course = Course.create(
  :name => data[:name],
  :desc => data[:desc],
  :cid => '9999999999',
  :creator => user
)


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

