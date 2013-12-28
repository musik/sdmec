class AddRealUrlToStore < ActiveRecord::Migration
  def change
    add_column :stores, :source_url, :string
  end
end
