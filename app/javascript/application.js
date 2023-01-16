// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

$('#email_email_type').change(function(){
	if($('#email_email_type').val() == 'Transaction'){
		$('#reminder_params').hide();
	}
	else {
		$('#reminder_params').show();
	}
});
