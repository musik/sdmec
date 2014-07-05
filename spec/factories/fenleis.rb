# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fenlei do
    name "MyString"
    slug "MyString"
    posts_count 1
    position 1
    lft 1
    rgt 1
    parent_id 1
    depth 1
  end
end
