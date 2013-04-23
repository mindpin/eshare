# -*- coding: utf-8 -*-
FactoryGirl.define do
  sequence(:num) {|n| n}

  factory :user, :aliases => [:creator, :receiver, :sharer] do
    login    {"user#{generate(:num)}"}
    name     {"用户#{generate(:num)}"}
    email    {"user#{generate(:num)}@edu.dev"}
    password '1234'
    role :teacher

    trait :teacher do
      role :teacher
    end

    trait :student do
      role :student
    end
  end
end
