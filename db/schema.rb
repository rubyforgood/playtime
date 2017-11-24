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

ActiveRecord::Schema.define(version: 20170908012526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "amazon_url"
    t.string "associate_url"
    t.integer "price_cents"
    t.string "asin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.integer "image_height"
    t.integer "image_width"
    t.text "name", null: false
  end

  create_table "pledges", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "wishlist_item_id"
    t.integer "quantity", default: 1, null: false
    t.index ["user_id", "wishlist_item_id"], name: "index_pledges_on_user_id_and_wishlist_item_id", unique: true
    t.index ["user_id"], name: "index_pledges_on_user_id"
    t.index ["wishlist_item_id"], name: "index_pledges_on_wishlist_item_id"
  end

  create_table "site_managers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "wishlist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_site_managers_on_user_id"
    t.index ["wishlist_id"], name: "index_site_managers_on_wishlist_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "name"
    t.text "email", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "amazon_user_id"
    t.string "zipcode"
    t.index ["amazon_user_id"], name: "index_users_on_amazon_user_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.integer "quantity", default: 0, null: false
    t.integer "wishlist_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "staff_message"
    t.integer "priority", default: 0, null: false
    t.index ["item_id"], name: "index_wishlist_items_on_item_id"
    t.index ["wishlist_id"], name: "index_wishlist_items_on_wishlist_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pledges", "users"
  add_foreign_key "pledges", "wishlist_items"
  add_foreign_key "site_managers", "users"
  add_foreign_key "site_managers", "wishlists"
  add_foreign_key "wishlist_items", "items"
  add_foreign_key "wishlist_items", "wishlists"
end