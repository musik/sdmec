# -*- encoding : utf-8 -*-
class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :data
      t.string :name

      t.timestamps
    end
  end
end
