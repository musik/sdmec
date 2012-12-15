# -*- encoding : utf-8 -*-
class AddIndexesOnPageViews < ActiveRecord::Migration
  def change
    rename_column :page_views,:object_type,:viewable_type
    rename_column :page_views,:object_id,:viewable_id
    add_index :page_views,[:viewable_type,:viewable_id],:name=>:viewable
    add_index :page_views,:created_at,:name=>:created_at
    add_index :page_views,:visitor_hash,:name=>:visitor
  end
end
