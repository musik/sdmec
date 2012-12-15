# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dach, :class => 'Dache' do
    context "MyString"
    context_id 1
    value "MyText"
  end
end
