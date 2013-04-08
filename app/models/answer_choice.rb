module AnswerChoice
  KINDS = {
    "SINGLE_CHOICE" => :answer_choice,
    "MULTIPLE_CHOICE" => :answer_choice,
    "FILL" => :answer_fill,
    "TRUE_FALSE" => :answer_true_false
  }

  def answer_choice=(choices)
    array = self.kind == 'SINGLE_CHOICE' ? [choices[0]] : choices.split('').uniq
    value = array.uniq.map do |choice|
     2 ** ('A'..'E').to_a.index(choice.to_s.upcase)
    end.sum
    write_attribute(:answer_choice_mask, value)
  end

  def answer_choice
    answer_choice_mask &&
    answer_choice_mask.to_s(2).chars.reverse.each_with_index.inject([]) do |acc, (num,index)|
      num == "1" ?  acc + [('A'..'E').to_a[index]] : acc
    end.compact.sort.join('')
  end

  def answer
    KINDS[self.kind]
  end

  def answer=(input)
    return if self.kind.blank?
    self.send "#{answer}=", input
  end
end