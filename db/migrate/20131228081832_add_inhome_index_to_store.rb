class AddInhomeIndexToStore < ActiveRecord::Migration
  def change
    add_index :stores,:inhome
  end
end
