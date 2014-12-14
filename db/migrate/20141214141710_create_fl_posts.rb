class CreateFlPosts < ActiveRecord::Migration
  def change
    create_table :fl_posts do |t|
      t.string :title
      t.string :summary
      t.string :keywords
      t.text :content
      t.references :user, index: true
      t.references :city, index: true
      t.references :category, index: true
      t.datetime :published_at
      t.boolean :publish

      t.timestamps
    end
  end
end
