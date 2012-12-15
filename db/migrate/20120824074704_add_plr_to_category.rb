class AddPlrToCategory < ActiveRecord::Migration
  def change
    add_column :categories,:parent_id,:integer
    add_column :categories,:lft,:integer
    add_column :categories,:rgt,:integer
    add_column :categories,:depth,:integer

    add_index :categories,[:parent_id,:lft,:rgt],:name=>:plr
  end
end
