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

  def course_ware_web_video_tag(course_ware)
    return '' if !course_ware.is_video?

    if course_ware.is_youku?
      id = "youku-#{course_ware.youku_video.video_id}"
      return capture_haml {
        haml_tag :div, :class => 'page-video-player web-video youku', :id => id, :data => {:id => course_ware.id}
      }
    end

    if course_ware.is_sina?
      id = "sina-#{course_ware.sina_video.video_id}"
      return capture_haml {
        haml_tag :div, :class => 'page-video-player web-video sina', :id => id, :data => {:id => course_ware.id}
      }
    end

    if course_ware.is_flv?
      id = "flv-#{course_ware.id}"
      url = course_ware.file_entity.attach.url

      return capture_haml {
        haml_tag :div, :class => 'page-video-player flv', :id => id, :data => {:url => url}
      }
    end

    return ''
  end

  def course_ware_read_count_html(course_ware, user)
    # .read
    #   %span.desc 学习完成度
    #   %span.l= @read_count
    #   %span /
    #   %span.r= @total_count
    capture_haml {
      haml_tag '.read', :data => {:id => course_ware.id} do
        haml_tag 'span.desc', '学习完成度'
        haml_tag 'span.rc', course_ware.read_count_of(user)
        haml_tag 'span', '/'
        haml_tag 'span.tc', course_ware.total_count
      end
    }
  end

  # 获取课件的学习进度
  def course_ware_read_percent(course_ware)
    course_ware.read_percent(current_user)
  end

  def course_ware_reading_css_class(course_ware)
    percent = course_ware.read_percent(current_user)
    return '' if percent == '0%'
    return 'read' if percent == '100%'
    return 'reading'
  end

  # 获取章节的学习进度
  def chapter_read_percent(chapter)
    chapter.read_percent(current_user)
  end

  # 获取课程的学习进度
  def course_read_percent(course)
    course.read_percent(current_user)
  end
end
