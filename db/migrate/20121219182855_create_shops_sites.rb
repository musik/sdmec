class CreateShopsSites < ActiveRecord::Migration
  def up
    create_table :sites_stores,:id=>false do |t|
      t.references :store
      t.references :site
      t.integer :priority
    end
    add_index :sites_stores,[:store_id,:site_id],:name=>:pri,:uniq=>true
  end
end
