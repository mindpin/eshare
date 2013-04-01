module AnswerChoice
  def answer_choice=(choices)
    value = choices.split('').map do |choice|
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
    TestQuestion::KINDS[self.kind]
  end

  def answer=(input)
    self.send "#{answer}=", input
  end
end