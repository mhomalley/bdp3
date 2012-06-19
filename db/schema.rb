# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "articles", :force => true do |t|
    t.integer  "issue_id"
    t.string   "author"
    t.string   "headline"
    t.text     "copy"
    t.string   "section"
    t.integer  "priority"
    t.datetime "posted_at"
  end

  add_index "articles", ["issue_id"], :name => "index_articles_on_issue_id"
  add_index "articles", ["priority"], :name => "index_articles_on_priority"
  add_index "articles", ["author"], :name => "index_articles_on_author"

  create_table "foo", :force => true do |t|
  end

  create_table "images", :force => true do |t|
    t.integer "article_id"
    t.string  "file_name"
    t.string  "author"
    t.text    "caption"
  end

  add_index "images", ["article_id"], :name => "index_images_on_article_id"

  create_table "issues", :force => true do |t|
    t.date    "date"
    t.integer "front_page_image"
  end

  add_index "issues", ["date"], :name => "index_issues_on_date"

  create_table "photos", :force => true do |t|
    t.string "name"
  end

  create_table "pub_dates", :force => true do |t|
    t.date "date"
  end

  create_table "states", :force => true do |t|
    t.string "name"
    t.string "abbreviation"
  end

  create_table "supporters", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "street_address"
    t.string  "city"
    t.string  "state"
    t.string  "zipcode"
    t.string  "phone"
    t.string  "email"
    t.string  "notes"
    t.integer "preferred_contact_method_id"
  end

  create_table "users", :force => true do |t|
    t.string "user_name"
    t.string "hashed_password"
  end

end
