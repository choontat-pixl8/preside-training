component extends="Shape"{
	public any function init(){
		if ( !objectEquals( this.init, super.init ) ) {
			super.init( argumentCollection=arguments );
		}

		return this;
	}

	public string function getType(){
		return "Square - #super.getType()#";
	}

	public string function getInheritedType(){
		return super.getType();
	}
}