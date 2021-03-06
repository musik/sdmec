# -*- encoding : utf-8 -*-
class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.decimal :price
      t.decimal :commission
      t.integer :commission_num
      t.integer :commission_rate
      t.decimal :commission_volume
      t.string :item_location
      t.string :nick
      t.string :num_iid
      t.integer :seller_credit_score
      t.integer :volume
      t.string :pic_url
      t.string :click_url
      t.string :shop_click_url
      t.integer :cid
      t.datetime :delist_time
      t.text :desc
      t.string :detail_url
      t.string :location_city
      t.string :location_state
      t.decimal :express_fee
      t.binary :item_imgs
      t.boolean :sell_promise

      t.datetime :detail_updated_at

      t.timestamps

    end
    add_index :items,:num_iid
    add_index :items,:cid
    add_index :items,:price
    add_index :items,:commission
    add_index :items,:commission_num
    add_index :items,:commission_rate
    add_index :items,:commission_volume
  end
end
