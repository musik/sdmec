# -*- encoding : utf-8 -*-
#encoding: utf-8

FactoryGirl.define do
  factory :tbpage do
    name '女人'
    slug 'lady'
    tburl 'http://love.taobao.com/guang/index.htm?spm=1001.1.202313.1'
    tagid 452
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
