# -*- encoding : utf-8 -*-
class AddItemsUpdatedToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :items_updated_at, :timestamp
  end
end
