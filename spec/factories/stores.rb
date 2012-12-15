# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    shop_title "MyString"
    seller_nick "MyString"
    seller_id 1
    city nil
    seller_credit 1
    shop_type "MyString"
    commission_rate "9.99"
    total_auction 1
    auction_count 1
    shop_id 1
    cid 1
    pic_path "MyString"
    created "2012-09-27 19:00:51"
    delivery_score "9.99"
    item_score "9.99"
    service_score "9.99"
  end
end
