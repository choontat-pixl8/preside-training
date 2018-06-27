component validationProvider="true" {
	property name="eventService" inject="EventService";

	public boolean function onlyAlphabeticChars( required string value, required struct data ){
		return REFind( "[^a-zA-Z]", trim( value ) )==0;
	}

	public boolean function eventServiceWorks(){
		return eventService.works();
	}

	public string function eventServiceWorks_js(){
		return "function( value, elem, params ){ console.log(arguments);window.$=$;return false;}";
	}

	public boolean function disqusIdType( string test, string custom, string fieldName, any value, struct formData ){
		return true;
	}

	public string function disqusIdType_js(){
		return "
			(function(){
				var element = $( 'input[type=hidden][name=idType]' )[0];

				Object.defineProperty( element, 'value', {
					  get: function(){
					  	return this.getAttribute( 'value' );
					  }
					, set: function( value ){
						this.setAttribute( 'value', value );

						$( '##type_id'    ).parents( '.form-group' ).css( { display: value==='id'    ? 'block' : 'none' } );
						$( '##type_email' ).parents( '.form-group' ).css( { display: value==='email' ? 'block' : 'none' } );

						return value;
					}
				} );

				element.value = element.getAttribute( 'value' );

				return function( value, elem, params ){ console.log(arguments);window.$=$;return false;};
			})()
		";
	}
}