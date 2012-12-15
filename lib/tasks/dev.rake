#encoding: utf-8
namespace :dev do
  desc "引入分类"
  task :categories => :environment do
    Category.import_all
  end
  task :catsword => :environment do
    Cat.pluck(:id).each do |id|
      Cat.find(id).delay.import_keywords
    end
  end
end
namespace :flush do 
  desc 'flush all stores'
  task :shops => :environment do
    puts `redis-cli -n 9 keys "views/*shop/*" |xargs redis-cli -n 9 del`  
  end
end
namespace :init do
  desc "引入store"
  task :stores=> :environment do
    Store::Jie.new.run_all_cities
  end
end
namespace :jobs do
  desc "把dach数据转入kt"
  task :dach => :environment do
    Dache.select(:id).all.each do |d|
      Dache.find(d.id).delay.move_to_kt
    end
  end
  desc "每日更新Tbpages"
  task :tbpage => :environment do
    Tbpage.pluck(:id).each do |id|
      Tbpage.find(id).delay.update_items
    end
  end
  desc "每日更新Ads"
  task :ad => :environment do
    Ad::IDS.each do |i|
      Ad.new(i).delay.update_items
    end
  end
  desc "空topic"
  task :topics =>:environment do
    Topic.unfetched.pluck(:id).each do |id|
      Topic.find(id).delay.init_data
    end
    # City.where("parent_id = 0").each do |c|
      # pp [c.id,c.name]
      # pp Topic.unfetched_in_city(c).count
    # end
  end
  desc "更新未更新"
  task :huati => :environment do
    Huati.delay.update_unpublished
  end
  desc "删除历史pageview"
  task :pv_clear => :environment do
    PageView.month_ago.delete_all
  end
  desc "导入百度"
  task :topbaidu => :environment do
    Topbaidu.delay.run_top
  end
  desc "导入百度全部"
  task :topbaidu_all => :environment do
    Topbaidu.delay.run_all
  end
end
