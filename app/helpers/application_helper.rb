module ApplicationHelper
  def truncate_u(text, length = 30, truncate_string = "...")
    # truncate(text, :length => length, :separator => truncate_string)
    return '' if text.blank?

    re = ''
    count = 0
    text.chars.each do |char|
      re = re + char
      count = count + (char.ascii_only? ? 0.5 : 1)
      return "#{re}#{truncate_string}" if count >= length
    end

    return re
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

  def avatar_link(user, style = :normal)
    if user.blank?
      return link_to 'javascript:;', :class => 'u-avatar' do
        avatar user, style
      end
    end

    link_to "/users/#{user.id}", :class => 'u-avatar' do
      avatar user, style
    end
  end

  def user_link(user)
    return '未知用户' if user.blank?
    link_to user.name, "/users/#{user.id}", :class=>'u-name'
  end

  def course_link(course)
    return '<s class="quiet">课程已删除</s>'.html_safe if course.blank?
    link_to course.name, "/courses/#{course.id}", :title => course.name
  end

  def course_ware_link(course_ware)
    return '<s class="quiet">小节已删除</s>'.html_safe if course_ware.blank?
    link_to course_ware.title, "/course_wares/#{course_ware.id}", :title => course_ware.title
  end

  def question_link(question)
    return '<s class="quiet">问题已删除</s>'.html_safe if question.blank?
    link_to "“#{truncate_u(question.title, 32)}”", "/questions/#{question.id}", :title => question.title 
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

  def follow_button(cur_user, user)
    # %a.page-follow.follow.btn.success{:data => {:id => user.id}}
    if cur_user.has_follow? user
      return capture_haml {
        haml_tag 'a.page-follow.unfollow.btn.small', '取消关注', :data => {:id => user.id}
      }
    end

    capture_haml {
      haml_tag 'a.page-follow.follow.btn.small', '关注', :data => {:id => user.id}
    }
  end

  def page_tag(tag, sub_path)
    # %a.tag{:href => "/tags/#{@sub_path}/#{tag.name}", :data => {:name => tag.name}}= tag.name
    capture_haml {
      haml_tag 'a.page-tag.tag', :href => "/tags/#{sub_path}/#{tag.name}", :data => {:name => tag.name} do
        haml_tag 'i.icon-tag'
        haml_tag 'span', tag.name
      end
    }
  end

  def user_roles_str(user)
    return '' if user.blank? || user.roles.blank?
    rrr = {
      :student => '学生',
      :teacher => '老师',
      :admin => '系统管理员',
      :manager => '教学管理员'
    }

    user.roles.map {|role|
      rrr[role]
    }.join('，')
  end

  module FeedHelper
    def feed_icon(feed)
      capture_haml {
        case feed.what
        when 'create_course_ware_reading', 'update_course_ware_reading'
          haml_tag 'div.feed-icon.course_ware_reading'
        when 'create_question', 'update_question'
          haml_tag 'div.feed-icon.question'
        when 'create_answer', 'update_answer'
          haml_tag 'div.feed-icon.answer'
        when 'create_answer_vote', 'update_answer_vote'
          haml_tag 'div.feed-icon.vote-up'
        else
          haml_tag 'div.feed-icon.common'
        end
      }
    end

    # 把 feed 信息转为页面显示的描述语句
    def feed_desc(feed)
      capture_haml {
        haml_tag 'span.feed-desc', :class => feed.what do
          case feed.what
            when 'create_question'
              haml_concat user_link(feed.who)
              haml_concat '提了一个问题'
              haml_concat question_link(feed.to)
            when 'update_question'
              haml_concat user_link(feed.who)
              haml_concat '修改了问题'
              haml_concat question_link(feed.to)

            when 'create_answer'
              if(answer = feed.to).present?
                if(question = answer.question).present?
                  haml_concat user_link(feed.who)
                  haml_concat '回答了问题'
                  haml_concat question_link(question)
                end
              end
            when 'update_answer'
              if(answer = feed.to).present?
                if(question = answer.question).present?
                  haml_concat user_link(feed.who)
                  haml_concat '修改了对问题'
                  haml_concat question_link(question)
                  haml_concat '的回答'
                end
              end

            when 'create_answer_vote', 'update_answer_vote'
              if (answer_vote = feed.to).present?
                if (answer = answer_vote.answer).present?
                  haml_concat user_link(feed.who)
                  haml_concat '赞成了'
                  haml_concat user_link(answer.creator)
                  haml_concat '在问题'
                  haml_concat question_link(answer.question)
                  haml_concat '中的回答'
                end
              end
            when 'create_course_ware_reading', 'update_course_ware_reading'
              if (course_ware_reading = feed.to).present?
                course = course_ware_reading.course
                chapter = course_ware_reading.chapter
                course_ware = course_ware_reading.course_ware

                haml_concat user_link(feed.who)
                haml_concat '学习了' if feed.what == 'update_course_ware_reading'
                haml_concat '开始学习' if feed.what == 'create_course_ware_reading'
                haml_concat course_link(course)
                haml_concat '课程下的'
                haml_concat course_ware_link(course_ware)
              end
            else
              haml_concat feed.what
          end
        end
      }
    end

    def feed_content(feed)
      capture_haml {
        case feed.what
        when 'create_course_ware_reading', 'update_course_ware_reading'
          if (course_ware_reading = feed.to).present?
            haml_concat '目前学习进度'
            haml_concat course_ware_reading.read_percent
          end
        when 'create_question', 'update_question'
          if (question = feed.to).present?
            haml_concat truncate_u(question.content, 140)
          end
        when 'create_answer', 'update_answer'
          if (answer = feed.to).present?
            haml_concat truncate_u(answer.content, 140)
          end
        when 'create_answer_voto', 'update_answer_vote'
          if (answer_vote = feed.to).present?
            if (answer = answer_vote.answer).present?
              haml_concat truncate_u(answer.content, 140)
            end
          end
        end
      }
    end
  end

  module TimeHelper
    def timeago(time)
      return content_tag(:span, '未知', :class=>'date') if time.blank?
      
      local_time = time.localtime
      content_tag(:span, _friendly_relative_time(local_time), :class=>'date', :'data-date'=>local_time.to_i)
    end

    private
      # 根据当前时间与time的间隔距离，返回时间的显示格式
      # 李飞编写
      def _friendly_relative_time(time)
        current_time = Time.now
        seconds = (current_time - time).to_i
        
        return '片刻前' if seconds < 0
        return "#{seconds}秒前" if seconds < 60        
        return "#{seconds/60}分钟前" if seconds < 3600
        return time.strftime('%H:%M') if seconds < 86400 && current_time.day == time.day
        return time.strftime("#{time.month}月#{time.day}日 %H:%M") if current_time.year == time.year
        return time.strftime("%Y年#{time.month}月#{time.day}日 %H:%M")
      end
  end

  include FeedHelper
  include TimeHelper
end
