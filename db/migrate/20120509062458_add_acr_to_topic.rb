# -*- encoding : utf-8 -*-
class AddAcrToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :acr, :string,:limit=>1
    add_column :topics, :acr2, :string,:limit=>2
    
    add_index :topics,:acr
    add_index :topics,:acr2
    add_index :topics,:volume
  end
end
