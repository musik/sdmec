# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    cid 1
    parent_id 1
    name "MyString"
    is_parent false
    status "MyString"
    sort_order 1
  end
end
