class AddUserToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :user_id, :integer
    add_column :users, :entries_count, :integer,default: 0
  end
end
