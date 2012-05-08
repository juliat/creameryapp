class Shift < ActiveRecord::Base
	
	# Validations
	# ====================================================================
	# a shift must have an associated assignment, a date, and a start time
	validates_date :date, :on_or_after => lambda { :assignment_starts }, :on_or_after_message => "must be on or after the start of the assignment"
	# validates_date :date, :on_or_after => lambda { self.assignment.start_date.to_date }, :on_or_after_message => "must be on or after the start of the assignment"
	validates_time :start_time #, :between => [Time.local(2000,1,1,11,0,0), Time.local(2000,1,1,23,0,0)]
	validates_time :end_time, :after => :start_time, :allow_blank => true
	validates_numericality_of :assignment_id, :only_integer => true, :greater_than => 0
  	# a shift can only be added to a current assignment
	validate :associated_assignment_is_active
	

	# Callbacks
	# ====================================================================
	before_create :set_shift_end_time
	
	
	# Relationships
	# ====================================================================
	has_many :shift_jobs, :dependent => :destroy
	has_many :jobs, :through => :shift_jobs
	belongs_to :assignment
	has_one :store, :through => :assignment
	has_one :employee, :through => :assignment
	
	# allow nesting of attributes for jobs within the shift form, and save them when
	# the shift is saved (unless they are blank)
	accepts_nested_attributes_for :jobs, :reject_if => lambda {|job| job[:name].blank? }
	
	
	# Scopes
	# ====================================================================
	# completed: returns all shifts in the system that have at least one
	# job associated with them
	scope :completed, joins(:shift_jobs).group(:shift_id)
	
	# incomplete: returns all shifts in the system that have NO
	# job associated with them
	# scope :incomplete, find_by_sql("select * from shifts where id not in(select shift_id from shift_jobs)")
	# scope :incomplete, where("id NOT IN (?)", Shift.completed.map{|shift| shift.id})
	scope :incomplete, joins("LEFT JOIN shift_jobs ON shifts.id = shift_jobs.shift_id").where('shift_jobs.job_id IS NULL')
	
	# for_store: returns all shifts that are associated with a given store
	# parameter - store_id
	scope :for_store, lambda{|store_id| joins(:assignment).where("store_id = ?", store_id) }
	
	# for_employee: returns all shifts that are associated with a given employee
	# parameter - employee_id
	scope :for_employee, lambda{|employee_id| joins(:assignment).where("employee_id = ?", employee_id) }
	
	# past: returns all shifts which have a date in the past
	scope :past, where('date < ?', Date.today)
	
	# upcoming: returns all shifts which have a date in the present or future
	scope :upcoming, where('date >= ?', Date.today)
	
	# for_next_days: returns all the upcoming shifts in the next x days
	# parameter - x
	scope :for_next_days, lambda{|x| where("start_time BETWEEN ? AND ?", Date.today.to_time, x.days.from_now)}
	
	# for_past_days: returns all past shifts in the previous x days (NOT including today)
	# parameter -x
	yesterday = Date.yesterday
	yesterday_time_end = Time.local(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59)
	# for_past_days goes from given days ago to the end of yesterday (11:59 pm)
	scope :for_past_days, lambda{|x| where("start_time BETWEEN ? AND  ?", (Date.today - x.days).to_time, yesterday_time_end)}
	
	# chronological: returns all shifts in chronological order
	scope :chronological, order('date', 'start_time')
	
	# by_store: returns all shifts ordered by store
	scope :by_store, joins(:store).order('name')
 
	# by_employee: returns all shifts ordered by employee's names (last, first)
	scope :by_employee, joins(:employee).order('last_name, first_name')
	
	
	# Methods
	# ====================================================================
	# completed? method returns true or false depending on whether or not 
	# there are any jobs associated with this shift
	def completed?
		# if there are no jobs associated with this shift, then it is not 
		# completed and this should return false
		return self.shift_jobs.count > 0
	end
	
	# Helper Methods
	# ===================================================================
	# hours method returns number of hours worked based on end_time - start_time
	def hours
		seconds_in_shift = end_time - start_time
		hours = seconds_in_shift/3600
		return hours
	end
	
	# creates a string to name the shift based on the start_time and the end_time
	def name
		return "#{start_time.strftime("%l:%M %p")} - #{end_time.strftime("%l:%M %p")}"
	end
		
	# Custom Validation Methods
	private
	def associated_assignment_is_active
		unless self.assignment.nil? || self.assignment.end_date.nil?
			errors.add(:assignment_id, "is not a current assignment at the creamery")
		end
	end
		
	# Callback Methods
	# ====================================================================
	# this callback will automatically set the end time of a new shif to three 
	# hours after the start time
	def set_shift_end_time
		self.end_time = self.start_time + 3.hours
	end
end
