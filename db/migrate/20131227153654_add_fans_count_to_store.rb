class AddFansCountToStore < ActiveRecord::Migration
  def change
    add_column :stores, :follow_count, :integer
  end
end
