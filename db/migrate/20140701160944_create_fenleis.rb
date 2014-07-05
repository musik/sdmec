class CreateFenleis < ActiveRecord::Migration
  def change
    create_table :fenleis do |t|
      t.string :name
      t.string :slug
      t.integer :posts_count,default: 0
      t.integer :position
      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.integer :depth
    end
    add_index :fenleis,:slug,uniq: true
  end
end
