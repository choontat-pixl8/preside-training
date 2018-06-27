component {
	public any function init(){
		variables._type = "Just a shape";
		
		return this;
	}

	public string function getType(){
		return variables._type ?: "General Shape";
	}

	public void function theShape(){}
}