require './script/makers/base_maker.rb'

class AttrsConfigMaker < BaseMaker
  set_producer {|data, _| AttrsConfig.create data}
end
