# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    employee = Employee.new
    employee.first_name = "John"
    employee.last_name = "Doe"
    employee.role = "admin"
    employee.date_of_birth = "1970-01-01"
    employee.phone = ""
    employee.ssn = "123456789"
    employee.save!
            
    admin = User.new
    admin.employee_id = employee.id
    admin.email = "julialt@gmail.com"
    admin.password ="secret"
    admin.password_confirmation = "secret"
    admin.save!