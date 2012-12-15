# -*- encoding : utf-8 -*-
class AddPublicToTopics < ActiveRecord::Migration
  def change
    add_column :topics,:public,:boolean
  end
end
