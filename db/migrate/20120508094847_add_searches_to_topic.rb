# -*- encoding : utf-8 -*-
class AddSearchesToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :volume, :integer
  end
end
