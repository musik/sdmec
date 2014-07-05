class AddContentToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :description, :string
    add_column :entries, :keywords, :string
    add_column :entries, :content, :text
  end
end
