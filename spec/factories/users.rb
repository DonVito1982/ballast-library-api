# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  role            :integer          not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { "member" }

    trait :librarian do
      role { "librarian" }
    end
  end
end
