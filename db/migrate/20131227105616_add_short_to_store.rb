class AddShortToStore < ActiveRecord::Migration
  def change
    add_column :stores, :short, :string
  end
end
