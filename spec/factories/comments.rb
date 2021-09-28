FactoryBot.define do
  factory :comment, class: Resource::Comment do
    name { FFaker::Name.name }
    body { FFaker::DizzleIpsum.paragraph }
  end
end