class AddCourseRelatedColumnToQuestions < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    belongs_to :model, :polymorphic => true
    belongs_to :course
    belongs_to :chapter
    belongs_to :course_ware
  end

  def change
    add_column :questions, :course_id,      :integer
    add_column :questions, :chapter_id,     :integer
    add_column :questions, :course_ware_id, :integer
    update_datas
  end

  def update_datas
    AddCourseRelatedColumnToQuestions::Question.record_timestamps = false
    questions = AddCourseRelatedColumnToQuestions::Question.all
    count = questions.count
    questions.each_with_index do |question, index|
      p "#{index+1}/#{count}"

      case question.model
      when Chapter
        chapter = question.model
        question.chapter = chapter
        question.course = chapter.course
      when CourseWare
        course_ware = question.model
        question.course_ware = course_ware
        question.chapter = course_ware.chapter
        question.course = question.chapter.course
      when Course
        question.course = question.model
      end

      question.save!
    end
  end
end
