# frozen_string_literal: true

FactoryBot.define do
  factory :mission do
    user
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    completed { false }
    priority { rand(0..3) }
    category { %w[work personal shopping health].sample }
    due_date { Faker::Time.forward(days: 7) }

    trait :completed do
      completed { true }
    end

    trait :high_priority do
      priority { 3 }
    end

    trait :low_priority do
      priority { 0 }
    end
  end
end
