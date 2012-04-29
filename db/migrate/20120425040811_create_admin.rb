class CreateAdmin < ActiveRecord::Migration
  # add default user admin to system when migration is run
  def up
    employee = Employee.new
    employee.first_name = "Julia"
    employee.last_name = "Teitelbaum"
    employee.role = "admin"
    employee.date_of_birth = "1992-01-21"
    employee.phone = "3038153575"
    employee.ssn = "123456789"
    employee.save!
            
    admin = User.new
    admin.employee_id = employee.id
    admin.email = "julialt@gmail.com"
    admin.password ="secret"
    admin.password_confirmation = "secret"
    admin.save!
  end
  
  # and delete that user when cleaning up migration
  def down
    employee = Employee.find_by_phone "3038153575"
    Employee.delete employee
    
    admin = User.find_by_email "julialt@gmail.com"
    User.delete admin
  end
end
