FactoryBot.define do
  factory :purchase_form do
    token { 'tok_abcdefghijk00000000000000000' }
    postal_code    { '123-4567' }
    prefecture_id  { Faker::Number.within(range: 2..47) }
    city           { Gimei.address.city.kanji }
    house_number   { Gimei.address.town.kanji }
    building_name  { Faker::Address.secondary_address }
    tel            { '09012345678' }
    user_id        { Faker::Number }
    item_id        { Faker::Number }
  end
end
