class CreateAdmin < ActiveRecord::Migration
  # add default user admin to system when migration is run
  def up
    admin = User.new
    admin.first_name = "Admin"
    admin.last_name ="Admin"
    admin.email = "admin@example.com"
    admin.password ="secret"
    admin.password_confirmation = "secret"
    admin.role ="admin"
    admin.save!
  end
  
  # and delete that user when cleaning up migration
  def down
    admin = User.find_by_email "admin@example.com"
    User.delete admin
  end
end
