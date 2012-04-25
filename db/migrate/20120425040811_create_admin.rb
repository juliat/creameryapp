class CreateAdmin < ActiveRecord::Migration
  # add default user admin to system when migration is run
  def up
    admin = User.new
    admin.first_name = "Julia"
    admin.last_name ="Teitelbaum"
    admin.email = "julialt@gmail.com"
    admin.password ="opensesame"
    admin.password_confirmation = "opensesame"
    admin.role ="admin"
    admin.save!
  end
  
  # and delete that user when cleaning up migration
  def down
    admin = User.find_by_email "julialt@gmail.com"
    User.delete admin
  end
end
