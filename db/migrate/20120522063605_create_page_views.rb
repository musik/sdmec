# -*- encoding : utf-8 -*-
class CreatePageViews < ActiveRecord::Migration
  def up
    create_table :page_views do |t|
      t.string :object_type
      t.integer :object_id
      t.string :user_agent,:ip,:referer,:visitor_hash
      t.integer :user_id
      t.timestamp :created_at
    end
  end

  def down
    drop_table :page_views
  end
end
