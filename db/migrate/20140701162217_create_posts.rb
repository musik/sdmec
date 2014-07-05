class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :summary
      t.string :keywords
      t.text :content
      t.string :source
      t.references :fenlei
      t.references :user
      t.references :city
      t.boolean :publish

      t.timestamps
    end
  end
end
