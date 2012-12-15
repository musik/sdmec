# -*- encoding : utf-8 -*-
class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name
      t.string :slug
      t.integer :parent_id
      t.boolean :use_subdomain
      t.boolean :zhixiashi
      # t.timestamps
    end
  end

  def self.down
    drop_table :cities
  end
end
