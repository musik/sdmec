class Post < ActiveRecord::Base
  #attr_accessible :city_id, :content, :fenlei_id, :publish, :source, :summary, :title, :user_id
  belongs_to :fenlei
  belongs_to :user
  belongs_to :city
  validates :title,presence: true
  validates :content,presence: true,length: {minimum: 100}
end
