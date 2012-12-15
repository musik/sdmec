require 'pp'
namespace :import do
  task :csv => :environment do
    require 'import_words'
    ImportWords.new.from_csv
  end
  task :cities => :environment do
    require 'import_cities'
    ImportCities.new.run
  end
  desc "start taoke shop import"
  task :shops => :environment do
    Store::TaokeShop.new.run
  end
end


namespace :fix do
  task :acrs => :environment do
    Topic.all.each do |t|
      t.update_acrs
    end
  end
  task :cts => :environment do
    Ct.delete_all(:fetched=>nil)
    pp Ct.count
  end
end

namespace :update do
  task :topic_items => :environment do
    # Topic.where(:items_updated_at=>nil).each do |t|
      # t.cached_items
      # pp Topic.find(t.id)
      # break
    # end
    pp Topic.unfetched.count
    Topic.all_update_items
  end
end
namespace :stat do
  task :topics => :environment do
    pp Topic.unfetched.count
  end
end
