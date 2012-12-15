class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :title
      t.integer :user_id
      t.references :city
      t.integer :seller_credit
      t.string :shop_type
      t.string :click_url
      t.decimal :commission_rate
      t.integer :total_auction
      t.integer :auction_count
      t.integer :sid
      t.integer :cid
      t.string :nick
      t.text :desc,:bulletin
      t.string :pic_path
      t.datetime :created,:modified
      t.decimal :delivery_score
      t.decimal :item_score
      t.decimal :service_score

      t.datetime :taoke_updated_at,:shop_updated_at

      t.timestamps
    end
    add_index :stores, :city_id
    add_index :stores, :cid
    add_index :stores, :nick
    add_index :stores, :seller_credit
    add_index :stores, :commission_rate
    add_index :stores, :total_auction
    add_index :stores, :taoke_updated_at
    add_index :stores, :shop_updated_at

  end
end
