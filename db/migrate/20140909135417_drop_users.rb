class DropUsers < ActiveRecord::Migration
   def up
    drop_table :users
  end

  def down
    create_table :users do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    end

  end
end
