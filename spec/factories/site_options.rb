# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site_option do
    site nil
    name "MyString"
    val ""
    autoload false
  end
end
