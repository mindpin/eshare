module CourseFeedTimelime
  module UserMethods
    def course_feed_timeline_db
      MindpinFeeds::Feed.find_by_sql(%`
          SELECT * FROM feeds
          WHERE
            (
              what = 'create_course_ware_reading'
              or
              what = 'update_course_ware_reading'
            )
          and
            user_id = #{self.id}
          and
            scene = 'course_ware_readings'

        UNION

          SELECT * FROM feeds
          WHERE
            what = 'create_question'
          and
            user_id = #{self.id}
          and
            scene = 'questions'

        UNION

          SELECT * FROM feeds
          WHERE
            what = 'create_practice_record'
          and
            user_id = #{self.id}
          and
            scene = 'practice_records'

        order by id desc
      `)
    end
  end

  module CourseMethods
    def course_feed_timeline_db
      MindpinFeeds::Feed.find_by_sql(%`
          SELECT feeds.* FROM feeds
            INNER JOIN course_ware_readings 
              ON
            feeds.to_type = 'CourseWareReading'
              and
            course_ware_readings.id = feeds.to_id
            INNER JOIN course_wares
              ON
            course_wares.id = course_ware_readings.course_ware_id
            INNER JOIN chapters
              ON
            chapters.id = course_wares.chapter_id
          WHERE
            (
              feeds.what = 'create_course_ware_reading'
              or
              feeds.what = 'update_course_ware_reading'
            )
          and
            feeds.scene = 'course_ware_readings'
          and
            chapters.course_id = #{self.id}

        UNION

          SELECT feeds.* FROM feeds
            INNER JOIN questions
              ON
            feeds.to_type = 'Question'
              and
            feeds.to_id = questions.id
          WHERE
            feeds.what = 'create_question'
          and
            questions.course_id = #{self.id}
          and
            feeds.scene = 'questions'

        UNION

          SELECT feeds.* FROM feeds
            INNER JOIN practice_records
              ON
            feeds.to_type = 'PracticeRecord'
              and
            feeds.to_id = practice_records.id
            INNER JOIN practices
              ON
            practices.id = practice_records.practice_id
            INNER JOIN chapters
              ON
            chapters.id = practices.chapter_id
          WHERE
            feeds.what = 'create_practice_record'
          and
            chapters.course_id = #{self.id}
          and
            feeds.scene = 'practice_records'

        order by id desc
      `)
    end
  end
end