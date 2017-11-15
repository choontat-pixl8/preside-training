component {
	private function index( event, rc, prc, args={} ) {
		var dimensionArr = listToArray( list=replace( args.dimensions, "x", "," ) );

		args.dimensions = {
			  "width"  = dimensionArr[1] & args.widthMeasurement
			, "height" = dimensionArr[2] & args.heightMeasurement
		};

		return renderView( view='widgets/video/index', args=args );
	}

	private function placeholder( event, rc, prc, args={} ) {
		var dimensionArr = listToArray( list=replace( args.dimensions, "x", "," ) );

		args.dimensions = {
			  "width"  = dimensionArr[1] & args.widthMeasurement
			, "height" = dimensionArr[2] & args.heightMeasurement
		};
		
		return renderView( view='widgets/video/placeholder', args=args );
	}
}
