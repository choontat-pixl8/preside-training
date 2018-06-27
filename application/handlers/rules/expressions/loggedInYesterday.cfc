/**
 * @expressionContexts user
 * @expressionCategory website_user
 * @feature            websiteUsers
 */
component {
	property name="websiteUserActionService" inject="WebsiteUserActionService";
	property name="websiteLoginService"      inject="WebsiteLoginService";

	/**
	 * @userId.fieldType   object
	 * @userId.object      website_user
	 * @userId.multiple    false
	 * @userId.placeholder User
	**/
	private boolean function evaluateExpression( 
		  required string  context
		, required struct  payload
		,          boolean _is=true
		,          string  userId=""
	) {
		if ( !websiteLoginService.isLoggedIn() ) {
			return false;
		}

		var yesterdayDateString = dateFormat( dateAdd( "d", -1, now() ), "yyyy-mm-dd" );
		var loggedInUserId      = userId.len() ? userId : websiteLoginService.getLoggedInUserId();
		var loggedInYesterday   = websiteUserActionService.hasPerformedAction(
			  type     = "login"
			, action   = "login"
			, userId   = loggedInUserId
			, dateFrom = "#yesterdayDateString# 00:00:00"
			, dateTo   = "#yesterdayDateString# 23:59:59"
		);

		return ( _is == loggedInYesterday );
	}
}
