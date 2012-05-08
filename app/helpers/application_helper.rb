module ApplicationHelper
	# make dates human readable in 05/08/2012 format
	def humanize_date(date)
		date.strftime("%m/%d/%Y")
	end
	
	def computerize_date(date)
		if date.nil?
			return ""
		end
		convert_to_datetime(date).to_s.slice(0..9)
	end
	
	# convert a string to a date (using Chronic, of course)
    def convert_to_date(string)
      return nil if (string.nil? || string.class != String)
      tmp = Chronic.parse(string)
      tmp ? tmp.to_date : nil
    end

    # convert a string to a datetime (Chronic's default)
    def convert_to_datetime(string)
      return nil if (string.nil? || string.class != String)
      Chronic.parse(string)
    end
	
	# helper to create popovers for jobs
	def job_popover(job)
		"<a href='#' class='job' rel='popover' data-content='#{job.description}' data-original-title='#{job.name}'>
		#{job.name}</a>"
	end
	
	# helper to generate html for custom buttons that use icon images
	def custom_button(entity, action, path, label)
		employee_icons = {"show"  => 'icons/icons_01.gif',
				"new"  => 'icons/icons_02.gif',
			       "del"  => 'icons/icons_03.gif',
				"edit"  => 'icons/icons_04.gif'
		}
		assign_icons = {  "show"  => 'icons/icons_05.gif',
				"new"  => 'icons/icons_06.gif',
			       "del"  => 'icons/icons_07.gif',
				"edit"  => 'icons/icons_08.gif'
		}
		store_icons = {   "show"  => 'icons/icons_09.gif',
				"new"  => 'icons/icons_10.gif',
			       "del"  => 'icons/icons_11.gif',
				"edit"  => 'icons/icons_12.gif'
		}
		job_icons =     { "show"  => 'icons/icons_13.gif',
				"new"  => 'icons/icons_14.gif',
				"del"  => 'icons/icons_15.gif',
			       "edit"  => 'icons/icons_16.gif'
		}	
		shift_icons =   { "show"  => 'icons/icons_17.gif',
				"new"  => 'icons/icons_18.gif',
				"del" => 'icons/icons_19.gif',
				"edit"  => 'icons/icons_20.gif'
		}							  
		icons = { "employee" => employee_icons, 
			  "assignment" => assign_icons, 
			  "store" => store_icons, 
			  "job" => job_icons, 
			  "shift" => shift_icons
		}
		img_tag = image_tag(icons[entity][action], :alt => label)
		return '<a href="' + path + '" class="btn btn-large ' + action + '">' + label + " " + img_tag + '</a>'
	end
end
