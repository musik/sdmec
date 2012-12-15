# -*- encoding : utf-8 -*-
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :cid
      t.integer :parent_cid
      t.string :name
      t.boolean :is_parent,:children_fetched
      t.string :status
      t.integer :sort_order

      t.timestamps
    end
    add_index :categories,:cid,:uniq=>true
  end
end
