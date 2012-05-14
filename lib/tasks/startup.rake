namespace :db do
  desc "Erase and fill database"
  task :startup => :environment do
    # Invoke rake db:migrate to generate the dev db
    Rake::Task['db:migrate'].invoke
        
    # Step 0: clear any old data in the db (in case this is being re-run for some reason)
    [Employee, Assignment, Store, Shift, User, Job, ShiftJob].each(&:delete_all)
    
  
    # Step 1a: Add some stores
    stores = {"Carnegie Mellon" => "5000 Forbes Avenue;15213", "Convention Center" => "1000 Fort Duquesne Blvd;15222", "Point State Park" => "101 Commonwealth Place;15222"}
    stores.each do |store|
      str = Store.new
      str.name = store[0]
      street, zip = store[1].split(";")
      str.street = street
      str.city = "Pittsburgh"
      str.zip = zip
      str.phone = rand(10 ** 10).to_s.rjust(10,'0')
      str.active = true
      str.save!
    end
    # Step 1b: Create three objects to represent the three stores
    cmu = Store.find_by_name "Carnegie Mellon"
    ccs = Store.find_by_name "Convention Center"
    psp = Store.find_by_name "Point State Park"
    
    
    # Step 2a: Add some jobs
    jobs = %w[Cashier Sweeping Mopping Serving Churning Setup Teardown]
    jobs.sort.each do |j|
      job = Job.new
      job.name = j
      job.description = "Best job ever and a true blessing for all who assigned such a glorious and noble task."
      job.active = true
      job.save!
    end
    # Step 2b: Create an array of active job ids to randomly sample later
    active_job_ids = Job.active.all.map(&:id)
    
    
    # ADD LEADERSHIP TEAM (with some change-ups)
    # Step 3a: Add Alex as manager and user and assign to CMU
    ae = Employee.new
    ae.first_name = "Alex"
    ae.last_name = "Heimann"
    ae.ssn = "123456789"
    ae.date_of_birth = "1993-01-25"
    ae.phone = "412-268-3259"
    ae.role = "manager"
    ae.active = true
    ae.save!
    au = User.new
    au.email = "alex@example.com"
    au.password = "secret"
    au.password_confirmation = "secret"
    au.employee_id = ae.id
    au.save!
    assign_alex = Assignment.new
    assign_alex.store_id = cmu.id
    assign_alex.employee_id = ae.id
    assign_alex.start_date = 14.months.ago.to_date
    assign_alex.end_date = nil
    assign_alex.pay_level = 6
    assign_alex.save!
    
    # Step 3b: Add Mark as admin and user
    me = Employee.new
    me.first_name = "Mark"
    me.last_name = "Heimann"
    me.ssn = "987654321"
    me.date_of_birth = "1993-01-25"
    me.phone = "412-268-8211"
    me.active = true
    me.role = "admin"
    me.save!
    mu = User.new
    mu.email = "mark@example.com"
    mu.password = "secret"
    mu.password_confirmation = "secret"
    mu.employee_id = me.id
    mu.save!
    
    # Step 3c: Add David as manager and user
    de = Employee.new
    de.first_name = "David"
    de.last_name = "Heimann"
    de.ssn = "310521992"
    de.date_of_birth = "1993-01-25"
    de.phone = "412-268-8211"
    de.active = true
    de.role = "manager"
    de.save!
    du = User.new
    du.email = "david@example.com"
    du.password = "secret"
    du.password_confirmation = "secret"
    du.employee_id = de.id
    du.save!
    assign_david = Assignment.new
    assign_david.store_id = ccs.id
    assign_david.employee_id = de.id
    assign_david.start_date = 14.months.ago.to_date
    assign_david.end_date = nil
    assign_david.pay_level = 5
    assign_david.save!
    
    # Step 3d: Add Pam as manager and user
    pe = Employee.new
    pe.first_name = "Pam"
    pe.last_name = "Heimann"
    pe.ssn = "310521959"
    pe.date_of_birth = "1959-07-23"
    pe.phone = "412-268-8259"
    pe.active = true
    pe.role = "manager"
    pe.save!
    pu = User.new
    pu.email = "pam@example.com"
    pu.password = "secret"
    pu.password_confirmation = "secret"
    pu.employee_id = pe.id
    pu.save!
    assign_pam = Assignment.new
    assign_pam.store_id = psp.id
    assign_pam.employee_id = pe.id
    assign_pam.start_date = 14.months.ago.to_date
    assign_pam.end_date = nil
    assign_pam.pay_level = 5
    assign_pam.save!
    
    
    # KEY USER TO TEST EMPLOYEE DASHBOARD
    # Step 4: Add Rachel as employee and user and assigned to first to PSP and then to CMU
    re = Employee.new
    re.first_name = "Rachel"
    re.last_name = "Heimann"
    re.ssn = "013125299"
    re.date_of_birth = "1993-01-25"
    re.phone = "412-268-8211"
    re.active = true
    re.role = "employee"
    re.save!
    ru = User.new
    ru.email = "rachel@example.com"
    ru.password = "secret"
    ru.password_confirmation = "secret"
    ru.employee_id = re.id
    ru.save!
    # assign her to PSP and then give her some shifts
    assign_rachel_to_psp = Assignment.new
    assign_rachel_to_psp.store_id = psp.id
    assign_rachel_to_psp.employee_id = re.id
    assign_rachel_to_psp.start_date = 55.weeks.ago.to_date
    assign_rachel_to_psp.end_date = nil
    assign_rachel_to_psp.pay_level = 1
    assign_rachel_to_psp.save!
    # Create some past shifts 
    54.downto(35) do |i|
      shift = Shift.new
      shift.assignment_id = assign_rachel_to_psp.id
      shift.date = i.weeks.ago.to_date
      st_hour = 8 + rand(6)
      st_min = (i.even? ? 0 : 30)
      shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
      shift.save!
      shift_job = ShiftJob.new
      shift_job.shift_id = shift.id
      shift_job.job_id = active_job_ids.sample
      shift_job.save!
    end
    
    # promote her to PSP and then give her more shifts
    assign_rachel_to_psp = Assignment.new
    assign_rachel_to_psp.store_id = psp.id
    assign_rachel_to_psp.employee_id = re.id
    assign_rachel_to_psp.start_date = 34.weeks.ago.to_date
    assign_rachel_to_psp.end_date = nil
    assign_rachel_to_psp.pay_level = 2
    assign_rachel_to_psp.save!
    # Create some past shifts 
    33.downto(15) do |i|
      shift = Shift.new
      shift.assignment_id = assign_rachel_to_psp.id
      shift.date = i.weeks.ago.to_date
      st_hour = 8 + rand(6)
      st_min = (i.even? ? 0 : 30)
      shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
      shift.save!
      shift_job = ShiftJob.new
      shift_job.shift_id = shift.id
      shift_job.job_id = active_job_ids.sample
      shift_job.save!
    end
    
    # now reassign her to CMU and give her some shifts
    assign_rachel_to_cmu = Assignment.new
    assign_rachel_to_cmu.store_id = cmu.id
    assign_rachel_to_cmu.employee_id = re.id
    assign_rachel_to_cmu.start_date = 14.weeks.ago.to_date
    assign_rachel_to_cmu.end_date = nil
    assign_rachel_to_cmu.pay_level = 3
    assign_rachel_to_cmu.save!
    # Create some past shifts
    86.downto(2) do |i|
      if i.even?
        shift = Shift.new
        shift.assignment_id = assign_rachel_to_cmu.id
        shift.date = i.days.ago.to_date
        st_hour = 8 + rand(6)
        st_min = (i%6==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
        shift_job = ShiftJob.new
        shift_job.shift_id = shift.id
        shift_job.job_id = active_job_ids.sample
        shift_job.save!
        if rand(2).zero?
          shift_job_2 = ShiftJob.new
          shift_job_2.shift_id = shift.id
          other_jobs = active_job_ids.select{|j| j != shift_job.job_id}
          shift_job_2.job_id = other_jobs.sample
          shift_job_2.save!
        end
      end
    end
    # Create some upcoming shifts for Rachel
    1.upto(23) do |i|
      if i.odd?
        shift = Shift.new
        shift.assignment_id = assign_rachel_to_cmu.id
        shift.date = i.days.from_now.to_date
        st_hour = 8 + rand(6)
        st_min = (i%5==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
      end
    end


    # ADDITIONAL EMPLOYEES TO CMU
    # Step 5a: Add Seth
    sv = Employee.new
    sv.first_name = "Seth"
    sv.last_name = "Vargo"
    sv.ssn = "913125213"
    sv.date_of_birth = "1992-03-15"
    sv.phone = "412-268-8206"
    sv.active = true
    sv.role = "employee"
    sv.save!
    # assign CMU and then add some shifts
    assign_seth = Assignment.new
    assign_seth.store_id = cmu.id
    assign_seth.employee_id = sv.id
    assign_seth.start_date = 5.weeks.ago.to_date
    assign_seth.end_date = nil
    assign_seth.pay_level = 3
    assign_seth.save!
    # Create some past shifts for Seth
    30.downto(1) do |i|
      shift = Shift.new
      shift.assignment_id = assign_seth.id
      shift.date = i.days.ago.to_date
      st_hour = 8 + rand(6)
      st_min = (i.even? ? 0 : 30)
      shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
      shift.save!
      shift_job = ShiftJob.new
      shift_job.shift_id = shift.id
      shift_job.job_id = active_job_ids.sample
      shift_job.save!
    end
    # Create some upcoming shifts for Seth
    3.upto(15) do |i|
      if i.odd?
        shift = Shift.new
        shift.assignment_id = assign_seth.id
        shift.date = i.days.from_now.to_date
        st_hour = 8 + rand(6)
        st_min = (i%5==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
      end
    end    
    
    # Step 5b: Add Molly
    ms = Employee.new
    ms.first_name = "Molly"
    ms.last_name = "Samuels"
    ms.ssn = "113125213"
    ms.date_of_birth = "1992-03-15"
    ms.phone = "412-268-8201"
    ms.active = true
    ms.role = "employee"
    ms.save!
    # assign CMU and then add some shifts
    assign_molly = Assignment.new
    assign_molly.store_id = cmu.id
    assign_molly.employee_id = ms.id
    assign_molly.start_date = 5.weeks.ago.to_date
    assign_molly.end_date = nil
    assign_molly.pay_level = 3
    assign_molly.save!
    # Create some past shifts 
    30.downto(1) do |i|
      if i.even?
        shift = Shift.new
        shift.assignment_id = assign_molly.id
        shift.date = i.days.ago.to_date
        st_hour = 8 + rand(6)
        st_min = (i%4==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
        shift_job = ShiftJob.new
        shift_job.shift_id = shift.id
        shift_job.job_id = active_job_ids.sample
        shift_job.save!
        end_hour = shift.start_time.hour + 4
        end_min = (i%6==0 ? 30 : 0)
        shift.end_time = Time.mktime(2000,1,1,end_hour,end_min,0)
        shift.save!
      end
    end
    # Create some upcoming shifts for Molly (with gaps to test widget)
    4.upto(12) do |i|
      if i.even?
        shift = Shift.new
        shift.assignment_id = assign_molly.id
        shift.date = i.days.from_now.to_date
        st_hour = 8 + rand(6)
        st_min = (i%6==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
      end
    end
        
    # Step 5c: Add Dominic
    dc = Employee.new
    dc.first_name = "Dominic"
    dc.last_name = "Cerminara"
    dc.ssn = "193124513"
    dc.date_of_birth = "1992-03-15"
    dc.phone = "412-268-8601"
    dc.active = true
    dc.role = "employee"
    dc.save!
    # assign CMU and then add some shifts
    assign_dom = Assignment.new
    assign_dom.store_id = cmu.id
    assign_dom.employee_id = dc.id
    assign_dom.start_date = 4.weeks.ago.to_date
    assign_dom.end_date = nil
    assign_dom.pay_level = 2
    assign_dom.save!
    # Create some past shifts 
    25.downto(1) do |i|
      if i.odd?
        shift = Shift.new
        shift.assignment_id = assign_dom.id
        shift.date = i.days.ago.to_date
        st_hour = 8 + rand(6)
        st_min = (i%3==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
        shift_job = ShiftJob.new
        shift_job.shift_id = shift.id
        shift_job.job_id = active_job_ids.sample
        shift_job.save!
        end_hour = shift.start_time.hour + 3
        end_min = (i%5==0 ? 30 : 0)
        shift.end_time = Time.mktime(2000,1,1,end_hour,end_min,0)
        shift.save!
      end
    end
    
    # Step 5c: Add Nolan
    nc = Employee.new
    nc.first_name = "Nolan"
    nc.last_name = "Carroll"
    nc.ssn = "153125213"
    nc.date_of_birth = "1992-03-15"
    nc.phone = "412-268-8301"
    nc.active = true
    nc.role = "employee"
    nc.save!
    # assign CMU and then add some shifts
    assign_nolan = Assignment.new
    assign_nolan.store_id = cmu.id
    assign_nolan.employee_id = nc.id
    assign_nolan.start_date = 4.weeks.ago.to_date
    assign_nolan.end_date = nil
    assign_nolan.pay_level = 2
    assign_nolan.save!
    # Create some past shifts 
    21.downto(1) do |i|
      if i.odd?
        shift = Shift.new
        shift.assignment_id = assign_nolan.id
        shift.date = i.days.ago.to_date
        st_hour = 8 + rand(6)
        st_min = (i%3==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
        shift_job = ShiftJob.new
        shift_job.shift_id = shift.id
        shift_job.job_id = active_job_ids.sample
        shift_job.save!
        end_hour = shift.start_time.hour + 3
        end_min = (i%5==0 ? 30 : 0)
        shift.end_time = Time.mktime(2000,1,1,end_hour,end_min,0)
        shift.save!
      end
    end
    
    # Step 5e: Add Ilyas
    ik = Employee.new
    ik.first_name = "Ilyas"
    ik.last_name = "Kenzhegaliyev"
    ik.ssn = "173125213"
    ik.date_of_birth = "1992-03-15"
    ik.phone = "412-268-8401"
    ik.active = true
    ik.role = "employee"
    ik.save!
    # assign CMU and then add some shifts
    assign_ilyas = Assignment.new
    assign_ilyas.store_id = cmu.id
    assign_ilyas.employee_id = ik.id
    assign_ilyas.start_date = 4.weeks.ago.to_date
    assign_ilyas.end_date = nil
    assign_ilyas.pay_level = 1
    assign_ilyas.save!
    # Create some past shifts 
    10.downto(1) do |i|
      if i.even?
        shift = Shift.new
        shift.assignment_id = assign_ilyas.id
        shift.date = i.days.ago.to_date
        st_hour = 8 + rand(6)
        st_min = (i%4==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
        shift_job = ShiftJob.new
        shift_job.shift_id = shift.id
        shift_job.job_id = active_job_ids.sample
        shift_job.save!
        end_hour = shift.start_time.hour + 3
        end_min = (i%6==0 ? 30 : 0)
        shift.end_time = Time.mktime(2000,1,1,end_hour,end_min,0)
        shift.save!
      end
    end
    
    # Step 5f: Add Faiz
    fa = Employee.new
    fa.first_name = "Faiz"
    fa.last_name = "Abbasi"
    fa.ssn = "183125213"
    fa.date_of_birth = "1992-03-15"
    fa.phone = "412-268-8501"
    fa.active = true
    fa.role = "employee"
    fa.save!
    # assign CMU and then add some shifts
    assign_faiz = Assignment.new
    assign_faiz.store_id = cmu.id
    assign_faiz.employee_id = fa.id
    assign_faiz.start_date = 4.weeks.ago.to_date
    assign_faiz.end_date = nil
    assign_faiz.pay_level = 1
    assign_faiz.save!
    # Create some past shifts 
    7.downto(1) do |i|
      if i.odd?
        shift = Shift.new
        shift.assignment_id = assign_faiz.id
        shift.date = i.days.ago.to_date
        st_hour = 8 + rand(6)
        st_min = (i%3==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
        shift_job = ShiftJob.new
        shift_job.shift_id = shift.id
        shift_job.job_id = active_job_ids.sample
        shift_job.save!
        end_hour = shift.start_time.hour + 3
        end_min = (i%5==0 ? 30 : 0)
        shift.end_time = Time.mktime(2000,1,1,end_hour,end_min,0)
        shift.save!
      end
    end
    
    # Step 5g: Add Adam (only two shifts; both incomplete)
    aw = Employee.new
    aw.first_name = "Adam"
    aw.last_name = "Weis"
    aw.ssn = "383125213"
    aw.date_of_birth = "1992-03-15"
    aw.phone = "412-268-8881"
    aw.active = true
    aw.role = "employee"
    aw.save!
    # assign CMU and then add some shifts
    assign_adam = Assignment.new
    assign_adam.store_id = cmu.id
    assign_adam.employee_id = aw.id
    assign_adam.start_date = 2.weeks.ago.to_date
    assign_adam.end_date = nil
    assign_adam.pay_level = 1
    assign_adam.save!
    # Create some past shifts 
    4.downto(1) do |i|
      if i.odd?
        shift = Shift.new
        shift.assignment_id = assign_adam.id
        shift.date = i.days.ago.to_date
        st_hour = 8 + rand(6)
        st_min = (i%3==0 ? 30 : 0)
        shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
        shift.save!
      end
    end
    
    # Step 5g: Add Dusty (assigned to CMU, but no shifts)
    dh = Employee.new
    dh.first_name = "Dusty"
    dh.last_name = "Heimann"
    dh.ssn = "573125213"
    dh.date_of_birth = "1992-03-15"
    dh.phone = "412-268-8866"
    dh.active = true
    dh.role = "employee"
    dh.save!
    # assign CMU and then add some shifts
    assign_dusty = Assignment.new
    assign_dusty.store_id = cmu.id
    assign_dusty.employee_id = dh.id
    assign_dusty.start_date = 2.weeks.ago.to_date
    assign_dusty.end_date = nil
    assign_dusty.pay_level = 1
    assign_dusty.save!

    # Step 6a: Add CJ to CCS
    cj = Employee.new
    cj.first_name = "CJ"
    cj.last_name = "Heimann"
    cj.ssn = "387125213"
    cj.date_of_birth = "1970-07-05"
    cj.phone = "412-268-1993"
    cj.active = true
    cj.role = "employee"
    cj.save!
    # assign CCS and then add some shifts
    assign_cj = Assignment.new
    assign_cj.store_id = ccs.id
    assign_cj.employee_id = cj.id
    assign_cj.start_date = 5.weeks.ago.to_date
    assign_cj.end_date = nil
    assign_cj.pay_level = 1
    assign_cj.save!
    # Create some past shifts for CJ
    30.downto(1) do |i|
      shift = Shift.new
      shift.assignment_id = assign_cj.id
      shift.date = i.days.ago.to_date
      st_hour = 8 + rand(2)
      st_min = (i.even? ? 0 : 30)
      shift.start_time = Time.mktime(2000,1,1,st_hour,st_min,0)
      shift.save!
      shift_job = ShiftJob.new
      shift_job.shift_id = shift.id
      shift_job.job_id = active_job_ids.sample
      shift_job.save!
      end_hour = shift.start_time.hour + 6
      shift.end_time = Time.mktime(2000,1,1,end_hour,0,0)
      shift.save!
    end
    
    # Step 6b: Add Bruce to PSP
    br = Employee.new
    br.first_name = "Bruce"
    br.last_name = "McCourtey"
    br.ssn = "932125213"
    br.date_of_birth = "1950-07-05"
    br.phone = "518-268-1993"
    br.active = true
    br.role = "employee"
    br.save!
    # assign PSP and then add some shifts
    assign_bruce = Assignment.new
    assign_bruce.store_id = psp.id
    assign_bruce.employee_id = br.id
    assign_bruce.start_date = 8.days.ago.to_date
    assign_bruce.end_date = nil
    assign_bruce.pay_level = 2
    assign_bruce.save!
    # Create some past shifts
    6.downto(1) do |i|
      shift = Shift.new
      shift.assignment_id = assign_bruce.id
      shift.date = i.days.ago.to_date
      st_hour = 11 + rand(2)
      shift.start_time = Time.mktime(2000,1,1,st_hour,0,0)
      shift.save!
      shift_job = ShiftJob.new
      shift_job.shift_id = shift.id
      shift_job.job_id = active_job_ids.sample
      shift_job.save!
    end
    
    # Finally, run the unit tests automatically once dev db is populated
    Rake::Task['test:units'].invoke
  end
end      
