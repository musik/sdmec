class AddCatIdOnStores < ActiveRecord::Migration
  def change
    add_column :stores, :cat_id, :integer
    add_index :stores,:cat_id,:name=>'index_cat'
    add_column :cats, :stores_count , :integer,:default=>0
  end
end
