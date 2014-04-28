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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140428024117) do

  create_table "sales", :force => true do |t|
    t.integer  "sale_type"
    t.decimal  "inlay",       :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "pt",          :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gold",        :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "kgold",       :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "day",         :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.date     "sale_time"
    t.integer  "store_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "other",       :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "old_gold",    :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "old_pt",      :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gold_jade",   :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "color_stone", :precision => 12, :scale => 2, :default => 0.0, :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "role"
    t.string   "other"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
