<html>
	<head>
		<style>
			.body{
				padding: 10px;
			}

			.input-group{
				height: 30px;
			}

			.input-group:not(:nth-last-child(1)){
				margin-bottom: 5px;
			}

			label{
				font-size   : 15pt;
				font-weight : bold;
				display     : inline-block;
				float       : left;
				min-width   : 150px;
				line-height : 30px;
			}

			label+div{
				line-height : 30px;
				display     : inline-block;
			}
		</style>
	</head>
	<body>
		<cfoutput>
			<h2>Booked Event Detail</h2>

			<div class="body">
				<div class="input-group">
					<label>First Name</label>
					<div>#args.firstName#</div>
				</div>
				<div class="input-group">
					<label>Last Name</label>
					<div>#args.lastName#"</div>
				</div>
				<div class="input-group">
					<label>No. Of Seats</label>
					<div>#args.seatCount#"</div>
				</div>
				<div class="input-group">
					<label>Total Price</label>
					<div>MYR #args.price#"</div>
				</div>
				<div class="input-group">
					<label>Sessions Booked</label>
					<div>#args.sessions#"</div>
				</div>
				<div class="input-group">
					<label>Special Requests</label>
					<div>#args.specialRequest#"</div>
				</div>
			</div>
		</cfoutput>
	</body>
</html>