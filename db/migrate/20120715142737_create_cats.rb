# -*- encoding : utf-8 -*-
class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.string :name
      t.string :slug
      t.string :oid
      t.integer :parent_id,:lft,:rgt,:depth
    end
    add_index :cats,:name
    add_index :cats,:slug
    add_index :cats,:parent_id
    add_index :cats,[:lft,:rgt],:name=>:lft_rgt
  end
end
