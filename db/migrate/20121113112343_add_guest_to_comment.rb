class AddGuestToComment < ActiveRecord::Migration
  def change
    add_column :comments, :guest_name, :string
    add_column :comments, :guest_email, :string
    add_column :comments, :guest_website, :string
  end
end
