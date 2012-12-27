class RemoveIndexesFromStore < ActiveRecord::Migration
  def change
    change_table :stores do |t|
      t.remove_index :name => "index_stores_on_comments_updated_at"
      t.remove_index :name => "index_stores_on_commission_rate"
      t.remove_index :name => "index_stores_on_delta"
      t.remove_index :name => "index_stores_on_seller_credit"
      t.remove_index :name => "index_stores_on_seller_score"
      #t.remove_index :name => "index_stores_on_shop_updated_at"
      #t.remove_index :name => "index_stores_on_taoke_updated_at"
      #t.remove_index :name => "index_stores_on_user_updated_at"
      t.remove_index :name => "index_stores_on_total_auction"
    end
    add_index :stores,:sid,:uniq=>true
  end
end
