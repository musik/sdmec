# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    url "MyString"
    name "MyString"
    pwd "MyString"
    qq "MyString"
    link_status false
    link_checked_at "2014-07-03 19:00:28"
    clicked_at "2014-07-03 19:00:28"
  end
end
