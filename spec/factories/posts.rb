FactoryBot.define do
  factory :post, class: Resource::Post do
    title { FFaker::DizzleIpsum.word }
    body { FFaker::DizzleIpsum.paragraph }
  end
end