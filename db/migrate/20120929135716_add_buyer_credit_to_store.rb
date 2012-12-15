class AddBuyerCreditToStore < ActiveRecord::Migration
  def change
    add_column :stores, :buyer_credit, :integer
    add_column :stores, :hangye, :string
    add_column :stores, :seller_rate, :decimal
    add_column :stores, :extra_data, :binary
    
    add_column :stores, :user_updated_at, :datetime
    add_column :stores, :comments_updated_at, :datetime
    add_index :stores, :user_updated_at
    add_index :stores, :comments_updated_at
  end
end
