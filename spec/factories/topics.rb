# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    name 'test'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
