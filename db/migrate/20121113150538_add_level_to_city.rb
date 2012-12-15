class AddLevelToCity < ActiveRecord::Migration
  def change
    add_column :cities, :level, :integer
    City.init_level
  end
end
