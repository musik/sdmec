class ChangeDeltaToFalse < ActiveRecord::Migration
  def up
    change_column_default :stores,:delta,false
  end

  def down
    change_column_default :stores,:delta,true
  end
end
