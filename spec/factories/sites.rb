# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "MyString"
    slug "MyString"
    description "MyText"
    user nil
  end
end
