module ApplicationHelper
	def humanize_date(date)
		date.strftime("%m/%d/%Y")
	end
end
