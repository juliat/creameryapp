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

ActiveRecord::Schema.define(:version => 20130220072443) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "allergies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "area_of_studies", :force => true do |t|
    t.integer  "woman_id"
    t.integer  "study_id"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "assignments", :force => true do |t|
    t.integer  "store_id"
    t.integer  "employee_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "pay_level"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "chore_assignments", :force => true do |t|
    t.integer  "sister_id"
    t.integer  "chore_id"
    t.integer  "trade_id"
    t.datetime "time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "chore_tasks", :force => true do |t|
    t.integer  "chore_id"
    t.integer  "task_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "chores", :force => true do |t|
    t.string   "name"
    t.string   "day"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contact_infos", :force => true do |t|
    t.string   "andrew_id"
    t.string   "alternate_email"
    t.string   "cell_phone"
    t.string   "alternate_phone"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "dietary_restrictions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ssn"
    t.date     "date_of_birth"
    t.string   "phone"
    t.string   "role"
    t.boolean  "active",        :default => true
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "exec_positions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "interactions", :force => true do |t|
    t.date     "date"
    t.time     "time"
    t.text     "comments"
    t.string   "communication_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "non_exec_positions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "email_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relationship"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "people_involveds", :force => true do |t|
    t.integer  "interaction_id"
    t.integer  "person_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "person_relationships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "relationship_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "relationships", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shift_jobs", :force => true do |t|
    t.integer  "shift_id"
    t.integer  "job_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shifts", :force => true do |t|
    t.integer  "assignment_id"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.text     "notes"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "sister_exec_offices", :force => true do |t|
    t.integer  "sister_id"
    t.integer  "exec_position_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "sister_non_exec_offices", :force => true do |t|
    t.integer  "sister_id"
    t.integer  "non_exec_position_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "sisters", :force => true do |t|
    t.integer  "woman_id"
    t.integer  "big_id"
    t.boolean  "active",         :default => true
    t.boolean  "house_resident"
    t.string   "meal_plan",      :default => "Full"
    t.boolean  "chores_exempt",  :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state",      :default => "PA"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "zip"
    t.string   "phone"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "studies", :force => true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tasks", :force => true do |t|
    t.integer  "depends_on"
    t.text     "description"
    t.integer  "difficulty"
    t.string   "days"
    t.boolean  "exception"
    t.string   "location"
    t.string   "time"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "topic_discusseds", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "interaction_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "trades", :force => true do |t|
    t.integer  "offerer_id"
    t.integer  "accepter_id"
    t.integer  "offer_assignment_id"
    t.integer  "accept_assignment_id"
    t.datetime "time_offered"
    t.datetime "time_accepted"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "employee_id"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "woman_activities", :force => true do |t|
    t.integer  "woman_id"
    t.integer  "activity_id"
    t.string   "role"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "woman_allergies", :force => true do |t|
    t.integer  "woman_id"
    t.integer  "allergy_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "woman_dietary_restrictions", :force => true do |t|
    t.integer  "woman_id"
    t.integer  "dietary_restriction_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "women", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.date     "birthday"
    t.string   "hometown"
    t.string   "dietary_restriction"
    t.string   "tshirt_size"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

end
