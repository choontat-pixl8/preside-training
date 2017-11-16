component {
	/**
	 * @websiteUser.inject presidecms:object:website_user
	 * @bCryptService.inject BCryptService
	 */

	public any function init( required any websiteUser, required any bCryptService ){
		_setWebsiteUser  ( arguments.websiteUser   );
		_setBCryptService( arguments.bCryptService );

		return this;
	}

	public boolean function registerUser( required struct websiteUserStruct ){
		var websiteUserData = {
			  "login_id"      = websiteUserStruct.email        ?: ""
			, "email_address" = websiteUserStruct.email        ?: ""
			, "display_name"  = websiteUserStruct.display_name ?: ""
			, "gender"        = websiteUserStruct.gender       ?: null
			, "password"      = _getBCryptService().hashPw( websiteUserStruct.password?:"" )
		};

		try {
			_getWebsiteUser().insertData( data=websiteUserData );
			return true;
		}
		catch ( any exception ) {
			return false;
		}
	}

	public boolean function isEmailAddressInUse( required string emailAddress ){
		var result = _getWebsiteUser().selectData(
			  selectFields = [ "COUNT( email_address ) > 0 AS emailAddressInUse" ]
			, filter       = { "email_address"=emailAddress }
		);

		return result.emailAddressInUse == '1';
	}

	public boolean function isLoginIdInUse( required string loginId ){
		var result = _getWebsiteUser().selectData(
			selectFields = [ "COUNT( login_id ) > 0 AS loginIdInUse" ]
			, filter     = { "login_id"=loginId }
		);

		return result.loginIdInUse == '1';
	}

	private void function _setWebsiteUser( required any websiteUser ){
		variables._websiteUser = arguments.websiteUser;
	}

	private any function _getWebsiteUser(){
		return variables._websiteUser;
	}

	private void function _setBCryptService( required any bCryptService ){
		variables._bCryptService = arguments.bCryptService;
	}

	private any function _getBCryptService(){
		return variables._bCryptService;
	}
}