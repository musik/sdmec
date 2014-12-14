# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141214141710) do

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.integer  "cid"
    t.integer  "parent_cid"
    t.string   "name"
    t.boolean  "is_parent"
    t.boolean  "children_fetched"
    t.string   "status"
    t.integer  "sort_order"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.boolean  "display"
    t.string   "slug"
    t.string   "nicename"
    t.string   "keywords"
    t.integer  "priority",         default: 5
  end

  add_index "categories", ["cid"], name: "index_categories_on_cid", using: :btree
  add_index "categories", ["display", "priority"], name: "display_with_priority", using: :btree
  add_index "categories", ["parent_id", "lft", "rgt"], name: "plr", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "cats", force: true do |t|
    t.string  "name"
    t.string  "slug"
    t.string  "oid"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.integer "stores_count", default: 0
    t.string  "title"
    t.string  "keywords"
    t.text    "description"
    t.integer "position",     default: 9
  end

  add_index "cats", ["lft", "rgt"], name: "lft_rgt", using: :btree
  add_index "cats", ["name"], name: "index_cats_on_name", using: :btree
  add_index "cats", ["parent_id"], name: "index_cats_on_parent_id", using: :btree
  add_index "cats", ["slug"], name: "index_cats_on_slug", using: :btree

  create_table "cities", force: true do |t|
    t.string  "name"
    t.string  "slug"
    t.integer "parent_id"
    t.boolean "use_subdomain"
    t.boolean "zhixiashi"
    t.integer "level"
  end

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type", default: ""
    t.string   "title",            default: ""
    t.text     "body"
    t.string   "subject",          default: ""
    t.integer  "user_id",          default: 0,  null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "guest_name"
    t.string   "guest_email"
    t.string   "guest_website"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "cts", id: false, force: true do |t|
    t.integer  "city_id"
    t.integer  "topic_id"
    t.integer  "items_count"
    t.text     "itemsdata"
    t.boolean  "fetched"
    t.datetime "fetched_at"
  end

  add_index "cts", ["city_id", "topic_id"], name: "index_cts_on_city_id_and_topic_id", using: :btree
  add_index "cts", ["items_count"], name: "index_cts_on_items_count", using: :btree

  create_table "daches", force: true do |t|
    t.string   "context_type"
    t.integer  "context_id"
    t.text     "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "daches", ["context_type", "context_id"], name: "index_daches_on_context_type_and_context_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "entries", force: true do |t|
    t.string   "url"
    t.string   "name"
    t.string   "pwd"
    t.string   "qq"
    t.boolean  "link_status"
    t.datetime "link_checked_at"
    t.datetime "clicked_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.string   "description"
    t.string   "keywords"
    t.text     "content"
  end

  create_table "fenleis", force: true do |t|
    t.string  "name"
    t.string  "slug"
    t.integer "posts_count", default: 0
    t.integer "position"
    t.integer "lft"
    t.integer "rgt"
    t.integer "parent_id"
    t.integer "depth"
  end

  add_index "fenleis", ["slug"], name: "index_fenleis_on_slug", using: :btree

  create_table "fl_categories", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "keywords"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fl_categories", ["parent_id", "lft", "rgt"], name: "plr", using: :btree
  add_index "fl_categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "fl_posts", force: true do |t|
    t.string   "title"
    t.string   "summary"
    t.string   "keywords"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "city_id"
    t.integer  "category_id"
    t.datetime "published_at"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fl_posts", ["category_id"], name: "index_fl_posts_on_category_id", using: :btree
  add_index "fl_posts", ["city_id"], name: "index_fl_posts_on_city_id", using: :btree
  add_index "fl_posts", ["user_id"], name: "index_fl_posts_on_user_id", using: :btree

  create_table "huatis", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "content"
    t.string   "acr",        limit: 1
    t.string   "acr2",       limit: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "published"
    t.integer  "priority",             default: 0
    t.boolean  "delta",                default: true, null: false
  end

  add_index "huatis", ["name"], name: "index_huatis_on_name", using: :btree
  add_index "huatis", ["priority"], name: "index_huatis_on_priority", using: :btree
  add_index "huatis", ["published"], name: "index_huatis_on_published", using: :btree
  add_index "huatis", ["slug"], name: "index_huatis_on_slug", using: :btree

  create_table "items", force: true do |t|
    t.string   "title"
    t.decimal  "price",               precision: 10, scale: 0
    t.decimal  "commission",          precision: 10, scale: 0
    t.integer  "commission_num"
    t.integer  "commission_rate"
    t.decimal  "commission_volume",   precision: 10, scale: 0
    t.string   "item_location"
    t.string   "nick"
    t.string   "num_iid"
    t.integer  "seller_credit_score"
    t.integer  "volume"
    t.string   "pic_url"
    t.string   "click_url"
    t.string   "shop_click_url"
    t.integer  "cid"
    t.datetime "delist_time"
    t.text     "desc"
    t.string   "detail_url"
    t.string   "location_city"
    t.string   "location_state"
    t.decimal  "express_fee",         precision: 10, scale: 0
    t.binary   "item_imgs"
    t.boolean  "sell_promise"
    t.datetime "detail_updated_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "items", ["cid"], name: "index_items_on_cid", using: :btree
  add_index "items", ["commission"], name: "index_items_on_commission", using: :btree
  add_index "items", ["commission_num"], name: "index_items_on_commission_num", using: :btree
  add_index "items", ["commission_rate"], name: "index_items_on_commission_rate", using: :btree
  add_index "items", ["commission_volume"], name: "index_items_on_commission_volume", using: :btree
  add_index "items", ["num_iid"], name: "index_items_on_num_iid", using: :btree
  add_index "items", ["price"], name: "index_items_on_price", using: :btree

  create_table "items_sites", id: false, force: true do |t|
    t.integer "item_id"
    t.integer "site_id"
  end

  add_index "items_sites", ["item_id", "site_id"], name: "pri", using: :btree

  create_table "links", force: true do |t|
    t.text     "data"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_views", force: true do |t|
    t.string   "viewable_type"
    t.integer  "viewable_id"
    t.string   "user_agent"
    t.string   "ip"
    t.string   "referer"
    t.string   "visitor_hash"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "page_views", ["created_at"], name: "created_at", using: :btree
  add_index "page_views", ["viewable_type", "viewable_id"], name: "viewable", using: :btree
  add_index "page_views", ["visitor_hash"], name: "visitor", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.string   "summary"
    t.string   "keywords"
    t.text     "content"
    t.string   "source"
    t.integer  "fenlei_id"
    t.integer  "user_id"
    t.integer  "city_id"
    t.boolean  "publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "site_options", force: true do |t|
    t.integer "site_id"
    t.string  "name"
    t.binary  "val"
    t.boolean "autoload"
  end

  add_index "site_options", ["site_id", "autoload"], name: "autoload", using: :btree
  add_index "site_options", ["site_id"], name: "index_site_options_on_site_id", using: :btree

  create_table "sites", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slogan"
  end

  add_index "sites", ["slug"], name: "index_sites_on_slug", using: :btree
  add_index "sites", ["user_id"], name: "index_sites_on_user_id", using: :btree

  create_table "sites_stores", id: false, force: true do |t|
    t.integer "store_id"
    t.integer "site_id"
    t.integer "priority"
  end

  add_index "sites_stores", ["store_id", "site_id"], name: "pri", using: :btree

  create_table "stores", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "city_id"
    t.integer  "seller_credit"
    t.string   "shop_type"
    t.string   "click_url"
    t.decimal  "commission_rate",     precision: 4,  scale: 2
    t.integer  "total_auction"
    t.integer  "auction_count"
    t.integer  "sid"
    t.integer  "cid"
    t.string   "nick"
    t.text     "desc"
    t.text     "bulletin"
    t.string   "pic_path"
    t.datetime "created"
    t.datetime "modified"
    t.decimal  "delivery_score",      precision: 2,  scale: 1
    t.decimal  "item_score",          precision: 2,  scale: 1
    t.decimal  "service_score",       precision: 2,  scale: 1
    t.datetime "taoke_updated_at"
    t.datetime "shop_updated_at"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "buyer_credit"
    t.string   "hangye"
    t.decimal  "seller_rate",         precision: 10, scale: 0
    t.binary   "extra_data"
    t.datetime "user_updated_at"
    t.datetime "comments_updated_at"
    t.integer  "seller_score"
    t.boolean  "delta",                                        default: false, null: false
    t.boolean  "active",                                       default: true
    t.integer  "cat_id"
    t.boolean  "inhome"
    t.string   "short"
    t.string   "source_url"
    t.integer  "follow_count"
    t.integer  "position",                                     default: 11
  end

  add_index "stores", ["cat_id"], name: "index_cat", using: :btree
  add_index "stores", ["cid"], name: "index_stores_on_cid", using: :btree
  add_index "stores", ["city_id"], name: "index_stores_on_city_id", using: :btree
  add_index "stores", ["inhome"], name: "index_stores_on_inhome", using: :btree
  add_index "stores", ["nick"], name: "index_stores_on_nick", using: :btree
  add_index "stores", ["sid"], name: "index_stores_on_sid", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "tbpages", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "tburl"
    t.datetime "last_fetched_at"
    t.integer  "tagid"
  end

  create_table "tcs", force: true do |t|
    t.integer "topic_id"
    t.integer "city_id"
  end

  add_index "tcs", ["city_id"], name: "index_tcs_on_city_id", using: :btree
  add_index "tcs", ["topic_id"], name: "index_tcs_on_topic_id", using: :btree

  create_table "topics", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "volume"
    t.string   "acr",              limit: 1
    t.string   "acr2",             limit: 2
    t.datetime "items_updated_at"
    t.boolean  "public"
    t.boolean  "delta",                      default: true, null: false
  end

  add_index "topics", ["acr"], name: "index_topics_on_acr", using: :btree
  add_index "topics", ["acr2"], name: "index_topics_on_acr2", using: :btree
  add_index "topics", ["name"], name: "name", using: :btree
  add_index "topics", ["public"], name: "index_topics_on_public", using: :btree
  add_index "topics", ["slug"], name: "slug", using: :btree
  add_index "topics", ["volume"], name: "index_topics_on_volume", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "entries_count",          default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
