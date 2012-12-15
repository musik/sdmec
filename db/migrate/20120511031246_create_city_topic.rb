# -*- encoding : utf-8 -*-
class CreateCityTopic < ActiveRecord::Migration
  def up
    create_table :cts,:id=>false do |t|
      t.references :city,:topic
      t.integer :items_count
    end
    add_index :cts,[:city_id,:topic_id],:uniq=>true
    add_index :cts,:items_count
  end

  def down
    drop_table :cts
  end
end
