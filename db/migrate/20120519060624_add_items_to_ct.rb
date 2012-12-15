# -*- encoding : utf-8 -*-
class AddItemsToCt < ActiveRecord::Migration
  def change
    add_column :cts, :itemsdata, :text
    add_column :cts, :fetched, :boolean
    add_column :cts, :fetched_at, :timestamp
  end
end
