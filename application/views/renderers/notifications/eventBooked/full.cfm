<cfoutput>
	<div class="panel panel-info notification-full">
		<div class="panel-heading">
			<div class="panel-title">Booked Event Detail</div>
		</div>
		<div class="panel-body">
			<div class="input-group">
				<label class="input-group-addon">First Name</label>
				<input type="text" class="form-control" value="#args.firstName#" readonly />
			</div>
			<div class="input-group">
				<label class="input-group-addon">Last Name</label>
				<input type="text" class="form-control" value="#args.lastName#" readonly />
			</div>
			<div class="input-group">
				<label class="input-group-addon">No. Of Seats</label>
				<input type="text" class="form-control" value="#args.seatCount#" readonly />
			</div>
			<div class="input-group">
				<label class="input-group-addon">Total Price</label>
				<input type="text" class="form-control" value="MYR #args.price#" readonly />
			</div>
			<div class="input-group">
				<label class="input-group-addon">Sessions Booked</label>
				<input type="text" class="form-control" value="#args.sessions#" readonly />
			</div>
			<div class="input-group">
				<label class="input-group-addon">Special Requests</label>
				<input type="text" class="form-control" value="#args.specialRequest#" readonly />
			</div>
		</div>
	</div>
</cfoutput>