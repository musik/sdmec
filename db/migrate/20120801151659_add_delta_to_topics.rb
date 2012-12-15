# -*- encoding : utf-8 -*-
class AddDeltaToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :delta, :boolean, :default => true,:null => false
    add_column :huatis, :delta, :boolean, :default => true,:null => false
  end
end
