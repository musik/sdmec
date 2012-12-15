# -*- encoding : utf-8 -*-
class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string :name
      t.string :slug,:uniq=>true
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
