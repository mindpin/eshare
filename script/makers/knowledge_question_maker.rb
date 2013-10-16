require './script/makers/base_maker.rb'

class KnowledgeQuestionMaker < BaseMaker
  set_producer do |args|
    KnowledgeQuestion.make(args[:kind], args)
  end
end
