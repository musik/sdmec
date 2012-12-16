# -*- encoding : utf-8 -*-
#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# puts 'SETTING UP DEFAULT USER LOGIN'
# user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
# puts 'New user created: ' << user.name
# user = User.create! :name => 'Second User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
# puts 'New user created: ' << user.name
# user.add_role :admin
# User.find(1).destroy
# User.find(2).destroy
# 
# Tbpage.create :name=>"女人",:tagid=>452
# Tbpage.create :name=>"衣服",:tagid=>453
# Tbpage.create :name=>"鞋子",:tagid=>454
# Tbpage.create :name=>"包包",:tagid=>188
# Tbpage.create :name=>"配饰",:tagid=>23
# Tbpage.create :name=>"家居",:tagid=>1138
# Tbpage.create :name=>"美容",:tagid=>1505
# Tbpage.create :name=>"男人",:tagid=>455
# 
# Topic.update_all :public=>true
def init_topic
Topic.clean_percents
Topic.init_public
end
def init_stores
  #Store::Jie.new.run_all_cities
  Store::TaokeShop.new.run
end
init_stores
