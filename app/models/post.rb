class Post < ActiveRecord::Base
  belongs_to :fenlei
  belongs_to :user
  belongs_to :city
  validates :title,presence: true
  validates :content,presence: true,length: {minimum: 100}
end
