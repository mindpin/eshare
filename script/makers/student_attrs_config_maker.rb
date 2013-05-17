require './script/makers/base_maker.rb'

class StudentAttrsConfigMaker < BaseMaker
  set_producer {|data, _| AttrsConfig.create data}
end
