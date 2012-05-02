ActionMailer::Base.smtp_settings = {
	:address 				=> "smtp.gmail.com",
	:port					=> 587,
	:user_name				=> "julialt",
	:password				=> "elliesmellyjellybelly",
	:authentication 		=> "plain",
	:enable_starttls_auto 	=> true
}
