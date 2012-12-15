class AddDeltaToStore < ActiveRecord::Migration
  def change
    add_column :stores, :delta, :boolean, :default => true,:null => false
  end
end
