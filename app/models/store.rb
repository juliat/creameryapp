class Store < ActiveRecord::Base
  # Callbacks
  before_save :reformat_phone
  before_save :find_store_coordinates
  
  # Set up this model to use gmaps for rails, a map-generating gem
  # https://github.com/apneadiving/Google-Maps-for-Rails/wiki/Model-Customization
  acts_as_gmappable :process_geocoding => false, :lat => 'latitude', :lng => 'longitude'
  
  # Relationships
  has_many :assignments
  has_many :employees, :through => :assignments
  has_many :shifts, :through => :assignments
  
  
  # Validations
  # make sure required fields are present
  validates_presence_of :name, :street, :city
  # if state is given, must be one of the choices given (no hacking this field)
  validates_inclusion_of :state, :in => %w[PA OH WV], :message => "is not an option"
  # if zip included, it must be 5 digits only
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long"
  # phone can have dashes, spaces, dots and parens, but must be 10 digits
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
  # make sure stores have unique names
  validates_uniqueness_of :name
  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  
  
  # Misc Constants
  STATES_LIST = [['Ohio', 'OH'],['Pennsylvania', 'PA'],['West Virginia', 'WV']]
  
  
  # Helper functions
    # ------------------------------
    def address
	    return street+", "+city+", "+state+" "+zip
    end
    
    def pretty_phone
	    return phone[0..2]+"-"+phone[3..5]+"-"+phone[6..9]
    end
    
    # returns stores active/inactive status as string
    def active_status
	if active
	    return "active"
	end
	return "inactive"
    end

    # returns number of shift hours worked in a given time range in the past
    def shift_hours_worked(past_n_days)
	# get all the hours for each employee and sum them up
	hours = employees.collect{|employee| employee.shift_hours_worked(past_n_days)}.inject(:+)
	return hours.to_i
    end
  
  # Callback code
  # -----------------------------
   # private
   # We need to strip non-digits before saving to db
   def reformat_phone
     phone = self.phone.to_s  # change to string in case input as all numbers 
     phone.gsub!(/[^0-9]/,"") # strip all non-digits
     self.phone = phone       # reset self.phone to new string
   end
   
    #Use a store_coordinates
    def find_store_coordinates
	# contact google's geocoding service and get the latitude and longitude
	coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{street}, #{city} #{state} #{zip}"
	if coord.success
	    # if the geocode requires was successful, use them to set the latitude and longitude
	    self.latitude, self.longitude = coord.ll.split(',')
	else
	    errors.add_to_base("Error with geocoding")
	end
    end
   
end
