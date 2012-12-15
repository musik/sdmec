class AddExtraToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :display, :boolean
    add_column :categories, :slug, :string
    add_column :categories, :nicename, :string
    add_column :categories, :keywords, :string
    add_column :categories, :priority, :integer,:default=>5
    
    add_index :categories,:slug
    #,:uniq=>true
    add_index :categories,[:display,:priority],:name=>"display_with_priority"
  end
end
