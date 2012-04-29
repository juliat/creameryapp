class Employee < ActiveRecord::Base
  
  # Validations
  validates_presence_of :first_name, :last_name
  validates_date :date_of_birth, :on_or_before => lambda { 14.years.ago }, :on_or_before_message => "must be at least 14 years old"
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only", :allow_blank => true
  validates_format_of :ssn, :with => /^\d{3}[- ]?\d{2}[- ]?\d{4}$/, :message => "should be 9 digits and delimited with dashes only"
  validates_inclusion_of :role, :in => %w[admin manager employee], :message => "is not an option"
  validates_uniqueness_of :ssn
  
  # Callbacks
  before_save :reformat_phone
  before_validation :reformat_ssn
  
  # Relationships
  has_many :assignments
  has_many :stores, :through => :assignments
  has_one :user
  has_many :shifts, :through => :assignments
  
    # allow nesting of attributes for assignments within the employees' form
    accepts_nested_attributes_for :assignments, :reject_if => lambda {|assignment| assignment[:name].blank? }
  
  # Scopes
  scope :younger_than_18, where('date_of_birth > ?', 18.years.ago.to_date)
  scope :is_18_or_older, where('date_of_birth <= ?', 18.years.ago.to_date)
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :regulars, where('role = ?', 'employee')
  scope :managers, where('role = ?', 'manager')
  scope :admins, where('role = ?', 'admin')
  scope :alphabetical, order('last_name, first_name')
  # search for all employees in the system by either first or last name
  scope :search, lambda { |term| where('first_name LIKE ? OR last_name LIKE ?', "#{term}%", "#{term}%") }
  
  
  # Class Methods
  
  # returns n employees who have worked the most hours in the past n days
    def self.top_employees(n_employees = 7, n_days = 14)
        # only employees (not managers or admins)
        employees = Employee.regulars.active.all
        # employees who have worked more than 0 hours, sorted by hours worked
        employees_with_hours = employees.select{|employee| employee.shift_hours_worked(n_days) > 0}
        top_employees = employees_with_hours.sort{|e1, e2| e2.shift_hours_worked(n_days) <=> e1.shift_hours_worked(n_days)}
        return top_employees.first(n_employees)   
    end
  
  
  # Other methods
  
  # returns number of shift hours worked in a given time range 
  def shift_hours_worked(past_n_days=14)
    shifts = Shift.for_employee(self.id).for_past_days(past_n_days)
    unless shifts.empty?
       hours = shifts.collect{|shift| shift.hours}.inject(:+)
    else
       hours = 0
    end
    return hours.to_i
  end
  
  def name
    "#{last_name}, #{first_name}"
  end
  
  def proper_name
    "#{first_name} #{last_name}"
  end
  
  def current_assignment
    curr_assignment = self.assignments.select{|a| a.end_date.nil?}
    # alternative method for finding current assignment is to use scope 'current' in assignments:
    # curr_assignment = self.assignments.current    # will also return an array of current assignments
    return nil if curr_assignment.empty?
    curr_assignment.first   # return as a single object, not an array
  end
  
  def manager
    if (self.role == "employee") && (self.current_assignment.nil? == false)
        manager = Assignment.for_store(self.current_assignment.store).for_role("manager").first.employee
        return manager
    else 
        return nil
    end
  end
  
  # returns the employee's most recent assignment (either their current assignment
  # or their most recent past assignment
  # def most_recent_assignment
	# return Assignment.for_employee(self.id).chronological.last
  # end
  
  def over_18?
    date_of_birth < 18.years.ago.to_date
  end
  
  def age
    (Time.now.to_s(:number).to_i - date_of_birth.to_time.to_s(:number).to_i)/10e9.to_i
  end
  
  	def pretty_phone
		return phone[0..2]+"-"+phone[3..5]+"-"+phone[6..9]
	end
  
  def pretty_ssn
	return ssn[0..2]+"-"+ssn[3..4]+"-"+ssn[5..8]
  end
  
  def active_status
		if active
			return "active"
		end
		return "inactive"
	end
    
  
  # Misc Constants
  ROLES_LIST = [['Employee', 'employee'],['Manager', 'manager'],['Administrator', 'admin']]
  
  
  # Callback code  (NOT DRY!!!)
  # -----------------------------
   private
   def reformat_phone
     phone = self.phone.to_s  # change to string in case input as all numbers 
     phone.gsub!(/[^0-9]/,"") # strip all non-digits
     self.phone = phone       # reset self.phone to new string
   end
   def reformat_ssn
     ssn = self.ssn.to_s      # change to string in case input as all numbers 
     ssn.gsub!(/[^0-9]/,"")   # strip all non-digits
     self.ssn = ssn           # reset self.ssn to new string
   end
end
