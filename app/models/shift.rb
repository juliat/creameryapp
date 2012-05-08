class Shift < ActiveRecord::Base
  # Relationships
  has_many :shift_jobs
  has_many :jobs, :through => :shift_jobs
  belongs_to :assignment
  has_one :store, :through => :assignment
  has_one :employee, :through => :assignment
  
  # Validations
  validates_date :date, :on_or_after => lambda { :assignment_starts }, 
				 :on_or_after_message => "must be on or after the start of the assignment",
				 :invalid_date_message => "is not a valid date"
  # validates_date :date, :on_or_after => lambda { self.assignment.start_date.to_date }, :on_or_after_message => "must be on or after the start of the assignment"
  validates_time :start_time #, :between => [Time.local(2000,1,1,11,0,0), Time.local(2000,1,1,23,0,0)]
  validates_time :end_time, :after => :start_time, :allow_blank => true
  validate :assignment_must_be_current
  validates_numericality_of :assignment_id, :only_integer => true, :greater_than => 0
  
  
	# Scopes
	# ====================================================================
	# completed: returns all shifts in the system that have at least one
	# job associated with them
	scope :completed, joins(:shift_jobs).group(:shift_id)
	
	# incomplete: returns all shifts in the system that have NO
	# job associated with them
	scope :incomplete, joins("LEFT JOIN shift_jobs ON shifts.id = shift_jobs.shift_id").where('shift_jobs.job_id IS NULL')
	
	# for_store: returns all shifts that are associated with a given store
	# parameter - store_id
	scope :for_store, lambda {|store_id| joins(:assignment, :store).where("assignments.store_id = ?", store_id) }

	# for_employee: returns all shifts that are associated with a given employee
	# parameter - employee_id
	scope :for_employee, lambda {|employee_id| joins(:assignment, :employee).where("assignments.employee_id = ?", employee_id) }
	
	# past: returns all shifts which have a date in the past
	scope :past, where('date < ?', Date.today)
	
	# upcoming: returns all shifts which have a date in the present or future	
	scope :upcoming, where('date >= ?', Date.today)
	
	# for_next_days: returns all the upcoming shifts in the next x days
	# parameter - x	
	scope :for_next_days, lambda {|x| where('date BETWEEN ? AND ?', Date.today, x.days.from_now.to_date) }
	
	# for_past_days: returns all past shifts in the previous x days (NOT including today)
	# parameter -x
	scope :for_past_days, lambda {|x| where('date BETWEEN ? AND ?', x.days.ago.to_date, 1.day.ago.to_date) }
	
	# chronological: returns all shifts in chronological order	
	scope :chronological, order(:date, :start_time)

	# by_store: returns all shifts ordered by store
	scope :by_store, joins(:assignment, :store).order(:name)
	
	# by_employee: returns all shifts ordered by employee's names (last, first)
	scope :by_employee, joins(:assignment, :employee).order(:last_name, :first_name)
  

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
		seconds_in_shift = start_time - end_time
		hours = seconds_in_shift/3600
		return hours
	end
	
	# creates a string to name the shift based on the start_time and the end_time
	def name
		return "#{start_time.strftime("%l:%M %p")} - #{end_time.strftime("%l:%M %p")}"
	end

	# Callback Methods
	# ====================================================================
	# this callback will automatically set the end time of a new shif to three 
	# hours after the start time
	before_create :set_shift_end_time
  

	private
	def assignment_starts
		@assignment_starts = self.assignment.start_date.to_date
	end

	def assignment_must_be_current
		unless self.assignment.nil? || self.assignment.end_date.nil?
		  errors.add(:assignment_id, "is not a current assignment at the creamery")
		end
	end

	def set_shift_end_time
		self.end_time = self.start_time + (3*60*60)
	end
end
