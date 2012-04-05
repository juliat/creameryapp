class Shifts < ActiveRecord::Base
	
	# Callbacks
	# ====================================================================
	before_create :set_shift_end_time
	
	
	# Relationships
	# ====================================================================

	has_many :jobs, :through => :shiftjobs
	belongs_to :assignment
	has_one :store, :through => :assignment
	has_one :employee, :through => :assignment
	
	# Scopes
	# ====================================================================
	# completed: returns all shifts in the system that have at least one
	# job associated with them
	# scope :completed, 
	
	# incomplete: returns all shifts in the system that have at least one 
	# job associated with them
	# scope :incomplete,
	
	# for_store: returns all shifts that are associated with a given store
	# parameter - store_id
	scope :for_store, lambda {|store_id| where("store_id = ?", store_id)}
	
	# for_employee: returns all shifts that are associated with a given employee
	# parameter - employee_id
	scope :for_employee, lambda{|employee_id| where("employee_id = ?", employee_id)}
	
	# past: returns all shifts which have a date in the past
	scope :past, where("start_time < ?", Time.local.now)
	
	# upcoming: returns all shifts which have a date in the present or future
	scope :upcoming, where ("start_time >= ?", Time.local.now)
	
	# for_next_days: returns all the upcoming shifts in the next x days
	# parameter - x
	scope :for_next_days, where("start_time BETWEEN ? AND ?", Time.local.now, Time.local.now + x.days)
	
	# for_past_days: returns all past shifts in the previous x days
	# parameter -x
	scope :for_past_days, where("start_time BETWEEN ? AND  ?", Time.local.now - x.days, Time.local.now)
	
	# chronological: returns all shifts in chronological order
	scope :chronological, order('start_time')
	
	# by_store: returns all shifts ordered by store
	scope :by_store, joins(:store).order('name')
 
	# by_employee: returns all shifts ordered by employee's names (last, first)
	scope :by_employee, joins(:employee).order('last_name, first_name')
	
	
	# Methods
	# ====================================================================
	# completed? method returns true of ralse depending on whether or not 
	# there are any jobs associated with this shift
	def completed?
		# if there are no jobs associated with this shift, then it is not 
		# completed and this should return false
		return !self.jobs.nil?
	end
	
	# Validations
	# ====================================================================
	# a shift must have an associated assignment, a date, and a start time
	validates_presence_of :assignment_id, :date, :start_time
	# a shift can only be added to a current assignment
	validate :associated_assignment_is_active
	
	# Custom Validation Methods
	private
	def associated_assignment_is_active
		# get all active assignments
		active_assignments = Assignments.current.map{|assignment| assignment.id}
		# check if this job's assignment is in the list
		return active_assignments.include?(self.assignment_id)
	end
		
	#def end_time_past?
		
	
	# Callbacks
	# ====================================================================
	# this callback will automatically set the end time of a new shif to three 
	# hours after the start time
	def set_shift_end_time
		self.end_time = self.start_time + 3.hours
	end
		
	
end
