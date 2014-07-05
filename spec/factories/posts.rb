# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    title "MyString"
    summary "MyString"
    content "MyText"
    source "MyString"
    fenlei ""
    user ""
    city ""
    publish false
  end
end
