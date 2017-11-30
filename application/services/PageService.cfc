component {
	/**
	 * @homepage.inject presidecms:object:homepage
	 */
	public any function init( required any homepage ){
		_setHomepage( homepage );

		return this;
	}

	public query function getHomepage(){
		return _getHomepage().selectData( selectFields=[ "page.id", "page.title" ] );
	}

	private void function _setHomepage( required any homepage ){
		variables._homepage = homepage;
	}

	private any function _getHomepage(){
		return variables._homepage;
	}
}