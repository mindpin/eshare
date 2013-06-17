FactoryGirl.define do
  factory :omniauth do
    user
    sequence(:uid) {|n| "fakeuid#{n}"}
    expires_at {rand(99999999999)}
    expires    {true}
    provider   {'weibo'}
    token      {randstr}
  end
end
