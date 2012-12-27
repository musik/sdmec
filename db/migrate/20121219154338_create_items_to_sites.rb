class CreateItemsToSites < ActiveRecord::Migration
  def change
    create_table :items_sites,:id=>false do |t|
      t.references :item
      t.references :site
    end
    add_index :items_sites,[:item_id,:site_id],:name=>:pri,:uniq=>true
  end
end
