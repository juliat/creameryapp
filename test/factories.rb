FactoryGirl.define do
  factory :store do
    name "CMU"
    street "5000 Forbes Avenue"
    city "Pittsburgh"
    state "PA"
    zip "15213"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    active true
  end
  
  factory :employee do
    first_name "Ed"
    last_name "Gruberman"
    ssn { rand(9 ** 9).to_s.rjust(9,'0') }
    date_of_birth 19.years.ago.to_date
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    role "employee"
    active true
  end
  
  factory :assignment do
    association :store
    association :employee
    start_date 1.year.ago.to_date
    end_date 1.month.ago.to_date
    pay_level 1
  end
  
  factory :shift do
	association :assignment
	date Date.today
	# set default start time to 1/21/2011 at 11:00 am
	start_time Time.local(2011,1,21,11,0,0)
	# set default end time to 1/21/2011 at 14:00 (2:00 pm)
	end_time Time.local(2011,1,21,14,0,0)
	notes "During this shift, velociraptors stormed the creamery. The employees
	valiantly battled with these ferocious dinosaurs, using lightsabers, phasers, 
	and mops."
  end
  
  factory :shift_job do
	association :shift
	association :job
  end
  
  factory :job do
	name "Cashier"
	description "Manned the cash register."
	active true
  end
  
  factory :user do
	association :employee
	email { |a| "#{a.first_name}.#{a.last_name}@example.com".downcase }
	# password_digest # what to put here ?
  end
end
