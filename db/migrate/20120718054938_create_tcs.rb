# -*- encoding : utf-8 -*-
class CreateTcs < ActiveRecord::Migration
  def change
    create_table :tcs do |t|
      t.references :topic
      t.references :city
    end
    add_index :tcs, :topic_id
    add_index :tcs, :city_id
  end
end
