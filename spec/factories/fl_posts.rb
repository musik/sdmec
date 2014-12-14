FactoryGirl.define do
  factory :fl_post, :class => 'Fl::Post' do
    title "MyString"
summary "MyString"
keywords "MyString"
content "MyText"
user nil
city nil
published_at "2014-12-14 22:17:10"
publish false
category nil
  end

end
