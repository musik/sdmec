class AddSellerscoreToStore < ActiveRecord::Migration
  def change
    add_column :stores, :seller_score, :integer
    add_index :stores,:seller_score
  end
end
