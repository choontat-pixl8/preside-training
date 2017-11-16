component {
	/**
	 * @programme.inject presidecms:object:programme
	 */

	public any function init( required any programme ){
		_setProgramme( programme );

		return this;
	}

	public query function getProgrammes( required string eventPageId ){
		var selectFields = [ "programme.label", "programme.start_datetime" ];
		var filter       = { "event_detail.id" = eventPageId };

		return _getProgramme().selectData( selectFields=selectFields, filter=filter );
	}

	private any function _getProgramme(){
		return variables._programme;
	}

	private void function _setProgramme( required any programme ){
		variables._programme = arguments.programme;
	}
}