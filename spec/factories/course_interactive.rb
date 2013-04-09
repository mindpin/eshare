FactoryGirl.define do
  factory :course_interactive do
    course
    date Time.now.strftime("%Y%m%d").to_i
    sum 0
  end
end