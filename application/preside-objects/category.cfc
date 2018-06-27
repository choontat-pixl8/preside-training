component dataManagerGroup="lookup" {
	property name="label" uniqueIndexes="uniqueCategoryName";
	
	public query function findById( required string categoryId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "category.id"=categoryId } );
	}
}