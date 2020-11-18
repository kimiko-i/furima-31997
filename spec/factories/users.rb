FactoryBot.define do
  factory :user do
    first_name { Gimei.name.first.kanji }
    last_name { Gimei.name.last.kanji }
    first_name_kana { Gimei.name.first.katakana }
    last_name_kana { Gimei.name.last.katakana }
    nickname { Faker::name }
    email { Faker::Internet.free_email }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end