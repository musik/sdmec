# -*- encoding : utf-8 -*-
class AddIndexpublicToTopics < ActiveRecord::Migration
  def change
    add_index :topics,:public
  end
end
