# -*- encoding : utf-8 -*-
class CreateDaches < ActiveRecord::Migration
  def change
    create_table :daches do |t|
      t.string :context_type
      t.integer :context_id
      t.text :value

      t.timestamps
    end
    add_index :daches,[:context_type,:context_id],:as=>:context
  end
end
