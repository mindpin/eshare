SimpleRedisCache.config do

  # 课件阅读进度
  # course_ware.read_percent(user)
  value_cache :name => :read_percent, :params => [:user], :caller => CourseWare do
    
    rules do

      after_save CourseWareReading do |reading|
        refresh_cache(reading.course_ware, reading.user)
      end

      after_save CourseWare do |course_ware|
          if course_ware.total_count_changed?
            course_ware.course_ware_readings.each do |reading|
              delete_cache(course_ware, reading.user)
            end
          end
      end

    end

  end

  # 章节阅读进度
  # chapter.read_percent(user)
  value_cache :name => :read_percent, :params => [:user], :caller => Chapter do
    
    rules do

      after_save CourseWareReading do |reading|
        chapter = reading.course_ware.chapter
        user = reading.user
        refresh_cache(chapter, user)
      end

      after_save CourseWare do |course_ware|
          if course_ware.total_count_changed?
            chapter = course_ware.chapter

            course_ware.course_ware_readings.each do |reading|
              delete_cache(chapter, reading.user)
            end
          end
      end

    end

  end

  # 课程阅读进度
  # course.read_percent(user)
  value_cache :name => :read_percent, :params => [:user], :caller => Course do
    
    rules do

      after_save CourseWareReading do |reading|
        course = reading.course_ware.chapter.course
        user = reading.user
        refresh_cache(course, user)
      end

      after_save CourseWare do |course_ware|
          if course_ware.total_count_changed?
            course = course_ware.chapter.course

            course_ware.course_ware_readings.each do |reading|
              delete_cache(course, reading.user)
            end
          end
      end

    end

  end

  # user.course_feed_timeline
  vector_cache  :name => :course_feed_timeline, 
                :params => [], :caller => User, 
                :model => MindpinFeeds::Feed do

    rules do

      after_create MindpinFeeds::Feed do |feed|
          user = feed.who
          case feed.to
          when CourseWareReading
            if feed.what == "create_course_ware_reading" || feed.what == "update_course_ware_reading"
              add_to_cache(feed.id, user)
            end
          when Question
            if feed.to.model.is_a?(CourseWare) && feed.what == "create_question"
              add_to_cache(feed.id, user)
            end
          when PracticeRecord
            if feed.what == "create_practice_record"
              add_to_cache(feed.id, user)
            end
          end
      end

    end

  end



  # course.course_feed_timeline
  vector_cache  :name => :course_feed_timeline, 
                :params => [], :caller => Course, 
                :model => MindpinFeeds::Feed do

    rules do

      after_save MindpinFeeds::Feed do |feed|

          case feed.to
          when CourseWareReading
            if feed.what == "create_course_ware_reading" || feed.what == "update_course_ware_reading"
              course = feed.to.course_ware.chapter.course
              add_to_cache(feed.id, course)
            end
          when Question
            if feed.to.model.is_a?(CourseWare) && feed.what == "create_question"
              course = feed.to.model.chapter.course
              add_to_cache(feed.id, course)
            end
          when PracticeRecord
            if feed.what == "create_practice_record"
              course = feed.to.practice.chapter.course
              add_to_cache(feed.id, course)
            end
          end

      end

    end

  end


  # user.question_feed_timeline
  vector_cache  :name => :question_feed_timeline, 
                :params => [], :caller => User, 
                :model => MindpinFeeds::Feed do

    rules do

      after_create MindpinFeeds::Feed do |feed|

          user = feed.who
          case feed.to
          when Question
            if feed.what == "create_question"
              add_to_cache(feed.id, user)
            end
          when Answer
            if feed.what == "create_answer"
              add_to_cache(feed.id, user)
            end
          when AnswerVote
            if feed.what == 'create_answer_vote' || feed.what == 'update_answer_vote'
              add_to_cache(feed.id, user)
            end
          end

      end

      after_destroy MindpinFeeds::Feed do |feed|
        user = feed.who
        if feed.to.is_a?(AnswerVote)
          remove_from_cache(feed.id, user)
        end
      end

    end

  end

  # question.question_feed_timeline
  vector_cache  :name => :question_feed_timeline, 
                :params => [], :caller => Question, 
                :model => MindpinFeeds::Feed do

    rules do

      after_create MindpinFeeds::Feed do |feed|

          user = feed.who
          case feed.to
          when Question
            if feed.what == "create_question"
              add_to_cache(feed.id, feed.to)
            end
          when Answer
            if feed.what == "create_answer"
              add_to_cache(feed.id, feed.to.question)
            end
          when AnswerVote
            if feed.what == 'create_answer_vote' || feed.what == 'update_answer_vote'
              question = feed.to.answer.question
              add_to_cache(feed.id, question)
            end
          end

      end

      after_destroy MindpinFeeds::Feed do |feed|
        if feed.to.is_a?(AnswerVote)
          question = feed.to.answer.question
          remove_from_cache(feed.id, question)
        end
      end

    end

  end
  
end