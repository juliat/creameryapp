class CreateAdmin < ActiveRecord::Migration
  # add default user admin to system when migration is run
  def up

  end
  
  # and delete that user when cleaning up migration
  def down
    employee = Employee.find_by_phone "3038153575"
    Employee.delete employee
    
    admin = User.find_by_email "julialt@gmail.com"
    User.delete admin
  end
end
