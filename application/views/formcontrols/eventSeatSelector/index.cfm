<cfscript>
	pricePerSeat  = args.pricePerSeat  ?: 0;
	remainingSeat = args.remainingSeat ?: 0;
	minSeatCount  = args.minValue      ?: 0;
	maxSeatCount  = args.maxValue      ?: 0;
	requiredField = args.required      ?: false;
	inputName     = args.name          ?: "";

	if ( remainingSeat < maxSeatCount && remainingSeat > 0 ) {
		maxSeatCount = remainingSeat;
	}
</cfscript>

<cfoutput>
	<input 
		id             = "seat-selector"
		name           = "#inputName#"
		type           = "number"
		class          = "form-control"
		min            = "#minSeatCount#"
		max            = "#maxSeatCount#" 
		#requiredField ? "required" : ""# />
	<label>
		Total: MYR
		<label id="total-seat-price">0</label>
		<br/>
		Remaining seats: #remainingSeat GT 0 ? remainingSeat : "unlimited"#
	</label>
	<script>
		(function(){

			var seatSelector     = document.getElementById( 'seat-selector' );
			var updateTotalPrice = function(){

				var pricePerSeat      = #pricePerSeat#;
				var selectedSeatCount = ( function( value ){
					if ( isNaN( value ) || value < #minSeatCount# ) {
						return 0;
					} else if ( value > #maxSeatCount# ){
						return #maxSeatCount#;
					}

					return value;
				} )( this.value );
				var totalPrice        = pricePerSeat * selectedSeatCount;
				var totalPriceLabel   = document.getElementById( 'total-seat-price' );

				if ( totalPriceLabel ) {
					totalPriceLabel.innerText = totalPrice.toString();
				}

				this.value = selectedSeatCount;
			};

			seatSelector.addEventListener( 'change', updateTotalPrice );
			seatSelector.addEventListener( 'keyup', updateTotalPrice );
		})();
	</script>
</cfoutput>