component hint="Sample Command" {

	property name="jsonRpc2Plugin" inject="coldbox:myPlugin:JsonRpc2";
	property name="square"         inject="Square";

	private any function index( event, rc, prc ) {
		var params  = jsonRpc2Plugin.getRequestParams();
		var cliArgs = IsArray( params.commandLineArgs ?: "" ) ? params.commandLineArgs : [];

		//return "I am a scaffolded command, please finish me off!" & arrayToList(cliArgs);
		return "
			getType          : #square.getType()#
			getInheritedType : #square.getInheritedType()#
		";
	}
}