class AddDeltaindexToStores < ActiveRecord::Migration
  def change
    add_index :stores,:delta
  end
end
