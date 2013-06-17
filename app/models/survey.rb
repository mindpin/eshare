class Survey < SimpleSurvey::Survey
  has_many :survey_result_items, :through => :survey_results

  def has_completed_by?(user)
    self.survey_results.where(:user_id => user.id).present?
  end

  def get_result_of(user)
    self.survey_results.where(:user_id => user.id).first
  end

  # 获取指定的题目中选择各个选项的人数
  def get_single_choice_item_option_count(item_number)
    # self.survey_result_items.where('item_number = ? AND answer_choice_mask & ? > 0', item_number, 2 ** option_idx).count
    # 查询太多，简化成一个SQL

    item = self.survey_template.survey_template_items[item_number - 1]
    opts_count = item.options.count

    select = (0...opts_count).map { |i|
      "SUM(answer_choice_mask & #{2 ** i} > 0) AS O#{i + 1}"
    }.join(',')

    sql = %~
      SELECT
      #{select}
      FROM survey_result_items
      INNER JOIN survey_results ON survey_result_items.survey_result_id = survey_results.id
      WHERE survey_results.survey_id = #{self.id}
      AND item_number = #{item_number}
    ~

    result = Survey.find_by_sql(sql)[0]

    return (0...opts_count).map {|i|
      result["O#{i + 1}"].to_i
    }

  end
end

