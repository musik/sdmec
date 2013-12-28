class AddPositionToStore < ActiveRecord::Migration
  def change
    add_column :stores, :position, :integer,default: 11
  end
end
