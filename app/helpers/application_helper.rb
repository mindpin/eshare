module ApplicationHelper
  def truncate_u(text, length = 30, truncate_string = "...")
    truncate(text, :length => length, :separator => truncate_string)
  end

  def page_file_uploader
    # .page-file-uploader
    #   .list
    #     .item.sample{:style => 'display:none;'}
    #       = page_progress_bar 61, :striped, :active
    #       .meta
    #         .filename foobarfoobarfoobarfoobarfoobarfoobarfoobar.zip
    #         .size 1.6M
    #         .percent 62%

    haml_tag '.page-file-uploader' do
      haml_tag '.list' do
        haml_tag 'div.item.sample', :style => 'display:none;' do
          haml_concat page_progress_bar(62, :striped, :active)
          haml_tag '.meta' do
            haml_tag '.filename', 'foobarfoobarfoobarfoobarfoobarfoobarfoobar.zip'
            haml_tag '.size', '1.6M'
            haml_tag '.percent', '62%'
          end
        end
      end
    end
  end

  def avatar(user, style = :normal)
    klass = ['page-avatar', style] * ' '

    if user.blank?
      alt   = t('common.unknown-user')
      src   = User.new.avatar.versions[style].url
      meta  = 'unknown-user'
    else
      alt   = user.name
      src   = user.avatar.versions[style].url
      meta  = dom_id(user)
    end

    image_tag src, :alt => alt,
                   :class => klass,
                   :data => {
                      :meta => meta
                   }
  end

  # 把 feed 信息转为页面显示的描述语句
  def feed_desc(feed)
    case feed.what
      when 'create_question'
        capture_haml {
          haml_concat user_link(feed.who)
          haml_concat '提了一个问题'
        }
      when 'create_answer'
        capture_haml {
          haml_concat user_link(feed.who)
          haml_concat '回答了这个问题'
        }
      when 'create_answervote', 'update_answervote'
        capture_haml {
          haml_concat user_link(feed.who)
          haml_concat '对这个回答表示支持'
        }
      else
        feed.what
    end
  end

  def user_link(user)
    return '未知用户' if user.blank?
    link_to user.name, "/users/#{user.id}", :class=>'u-name'
  end

  def web_video_tag(course_ware)
    return '' if course_ware.kind != 'youku'
    id = course_ware.url.split('_')[2].split('.')[0]

    capture_haml {
      haml_tag :iframe, :height => 498, 
                        :width => 510, 
                        :frameborder => 0,
                        :allowfullscreen => true,
                        :src => "http://player.youku.com/embed/#{id}"
    }
  end
end
