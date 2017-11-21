component extends="preside.system.config.Config" {

	public void function configure() {
		super.configure();

		settings.preside_admin_path  = "admin";
		settings.system_users        = "sysadmin";
		settings.default_locale      = "en";

		settings.default_log_name    = "practicepreside";
		settings.default_log_level   = "information";
		settings.sql_log_name        = "practicepreside";
		settings.sql_log_level       = "information";

		settings.ckeditor.defaults.stylesheets.append( "css-bootstrap" );
		settings.ckeditor.defaults.stylesheets.append( "css-layout" );

		settings.features.websiteUsers.enabled = true;

		
		settings.features.formbuilder.enabled = true;

		settings.enum.gender = [ "Male", "Female" ];

		settings.assetmanager.derivatives.pdfPreview = {
			  permissions = "inherit"
			, transformations = [
				  { method="pdfPreview" , args={ page=1                }, inputfiletype="pdf", outputfiletype="jpg" }
				, { method="shrinkToFit", args={ width=200, height=400 } }
			  ]
		};

		settings.email.recipientTypes.eventBooker = {
			  parameters = [ "first_name", "last_name", "seat_count", "priceInMYR", "special_request", "sessions" ]
			, filterObject = "booking"
			, gridFields = [ "first_name", "last_name", "email" ]
			, recipientIdLogProperty = "event_delegate_recipient"
		};

		settings.email.templates.eventBookingConfirmation = {
			  recipientType = "eventBooker"
		};

		settings.notificationTopics.append( "eventBooked" );
		settings.notificationTopics.append( "seatSoldOut" );

		_setupInterceptors();

		coldbox.requestContextDecorator = "app.decorators.RequestContextDecorator";
	}

	private void function _setupInterceptors(){

		interceptors.append( { class="app.interceptors.SeatSoldOutInterceptor",       properties={} } );

	}
}
