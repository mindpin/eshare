# Load the rails application
require File.expand_path('../application', __FILE__)


# 中文分词
require "rmmseg"
RMMSeg::Dictionary.load_dictionaries


# Initialize the rails application
Eshare::Application.initialize!
