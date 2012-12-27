class FixDecimal < ActiveRecord::Migration
  def change
    change_column :stores,:delivery_score,:decimal,:precision => 2, :scale => 1
    change_column :stores,:item_score,:decimal,:precision => 2, :scale => 1
    change_column :stores,:service_score,:decimal,:precision => 2, :scale => 1
    change_column :stores,:commission_rate,:decimal,:precision => 4, :scale => 2
  end
end
