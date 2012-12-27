class AddSloganToSite < ActiveRecord::Migration
  def change
    add_column :sites, :slogan, :string
  end
end
