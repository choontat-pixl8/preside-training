component {
	property name="formsService"       inject="FormsService";
	property name="websiteUserService" inject="WebsiteUserService";

	private function index( event, rc, prc, args={} ){
		return renderView(
			  view          = 'page-types/user_registration/index'
			, presideObject = 'user_registration'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}

	public function registerUser( event, rc, prc, args={} ){
		var formData = event.getCollectionForForm( "user.registration" );

		for ( var data in formData ) {
			formData[ data ] = filterHTML( formData[ data ] );
		}

		var validationResult    = validateForm( "user.registration", formData );
		var validInputs         = ( len ( validationResult.listErrorFields() ) == 0 );
		var registrationSuccess = false;

		if ( validInputs ) {
			registrationSuccess = websiteUserService.registerUser( formData );

			if ( !registrationSuccess ) {
				if ( websiteUserService.isLoginIdInUse( formData.email ) ) {
					validationResult.addError( 
						  fieldName = "email"
						, message   = "user.registration:validation.error.email.exists"
						, params    = [ formData.email ]
					);
				}
			}
		}

		setNextEvent(
			  url           = event.buildLink( page="user_registration" )
			, persistStruct = {
				  success          = registrationSuccess
				, validationResult = validationResult
			}
		 );
	}
}