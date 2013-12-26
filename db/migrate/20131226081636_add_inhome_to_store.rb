class AddInhomeToStore < ActiveRecord::Migration
  def change
    add_column :stores, :inhome, :boolean
  end
end
