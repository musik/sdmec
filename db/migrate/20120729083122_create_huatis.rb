# -*- encoding : utf-8 -*-
class CreateHuatis < ActiveRecord::Migration
  def change
    create_table :huatis do |t|
      t.string :name
      t.string :slug
      t.string :content
      t.string   "acr",              :limit => 1
      t.string   "acr2",             :limit => 2
      t.timestamps
      
      t.boolean :published
      t.integer :priority,:default=>0
    end
    add_index :huatis,:slug,:uniq=>true
    add_index :huatis,:name,:uniq=>true
    add_index :huatis,:published
    add_index :huatis,:priority
  end
end
