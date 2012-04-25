class CreateAdmin < ActiveRecord::Migration
  # add default user admin to system when migration is run
  def up
    admin = User.new
    admin.email = "julialt@gmail.com"
    admin.password ="opensesame"
    admin.password_confirmation = "opensesame"
    admin.save!
  end
  
  # and delete that user when cleaning up migration
  def down
    admin = User.find_by_email "julialt@gmail.com"
    User.delete admin
  end
end
