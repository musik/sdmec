class CreateSiteOptions < ActiveRecord::Migration
  def change
    create_table :site_options do |t|
      t.references :site
      t.string :name
      t.binary :val
      t.boolean :autoload
    end
    add_index :site_options, :site_id
    add_index :site_options, [:site_id,:autoload],:name=>:autoload
  end
end
