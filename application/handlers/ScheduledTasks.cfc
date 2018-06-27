component {
    property name="elasticSearchEngine"  inject="elasticSearchEngine";
	/**
	 * Rebuilds the search indexes from scratch, ensuring that they are all up to date with the latest data
	 *
	 * @displayName Rebuild search indexes
	 * @displayGroup Search Engine
	 * @schedule    0 *\/60 * * * *
	 * @priority    13
	 * @timeout     10800
	 */
    private boolean function rebuildSearchIndexes( event, rc, prc, logger ) output=false {
        return elasticSearchEngine.rebuildIndexes( logger=arguments.logger ?: NullValue() );
    }

}