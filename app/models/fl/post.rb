class Fl::Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :category
end
