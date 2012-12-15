# -*- encoding : utf-8 -*-
class CreateTbpages < ActiveRecord::Migration
  def self.up
    create_table :tbpages do |t|
      t.string :name
      t.string :slug
      t.string :tburl
      t.timestamp :last_fetched_at
      t.integer :tagid
    end
  end

  def self.down
    drop_table :tbpages
  end
end
