class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.references :user

      t.timestamps
    end
    add_index :sites, :user_id
    add_index :sites, :slug
  end
end
