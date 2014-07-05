class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :url
      t.string :name
      t.string :pwd
      t.string :qq
      t.boolean :link_status
      t.datetime :link_checked_at
      t.datetime :clicked_at

      t.timestamps
    end
  end
end
