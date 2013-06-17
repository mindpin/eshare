# -*- coding: utf-8 -*-
require "spec_helper"

describe "修复当excel里用户名栏为数字时的导入错误" do
  context {

    let(:file) {File.open("./spec/support/resources/users.xlsx")}
    subject {User.import_excel(file, :student, password = "1234")}
    after {file.close}

    it {expect {subject}.to change {User.count}.by(3)}

    it {
      users = subject
      u = users.first
      u.valid?
      p u.errors
      u.errors.should be_blank
    }
  }
end
