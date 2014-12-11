class CreateFlCategories < ActiveRecord::Migration
  def change
    create_table :fl_categories do |t|
      t.string :name
      t.string :slug
      t.string :keywords
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"

      t.timestamps
    end
  add_index "fl_categories", ["parent_id", "lft", "rgt"], name: "plr", using: :btree
  add_index "fl_categories", ["slug"], name: "index_categories_on_slug", using: :btree
  end
end
