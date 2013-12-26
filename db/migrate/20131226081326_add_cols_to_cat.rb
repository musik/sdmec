class AddColsToCat < ActiveRecord::Migration
  def change
    add_column :cats, :title, :string
    add_column :cats, :keywords, :string
    add_column :cats, :description, :text
    add_column :cats, :position, :integer,default: 9
  end
end
