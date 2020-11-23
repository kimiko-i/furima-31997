FactoryBot.define do
  factory :item do
    name { Faker::Lorem.sentence }
    price { Faker::Number.within(range: 300..9_999_999) }
    detail { Faker::Lorem.sentence }
    category_id { Faker::Number.within(range: 2..11) }
    status_id { Faker::Number.within(range: 2..7) }
    shipping_id { Faker::Number.within(range: 2..3) }
    send_from_id { Faker::Number.within(range: 2..47) }
    shipment_day_id { Faker::Number.within(range: 2..4) }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
