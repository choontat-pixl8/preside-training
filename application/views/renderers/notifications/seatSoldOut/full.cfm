<cfset bookersDetail = args.bookersDetail?:queryNew("") />
<cfoutput>
	<div class="panel panel-info">
		<div class="panel-heading">
			<h2>Bookers' Detail</h2>
		</div>

		<table class="table table-hover">
			<thead>
				<tr>
					<th>No.</th>
					<th>First Name</th>
					<th>Last Name</th>
					<th>Email Address</th>
					<th>Seat(s) Booked</th>
					<th>Price (MYR)</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="#bookersDetail#">
					<tr>
						<td>#bookersDetail.currentRow##list?:""#</td>
						<td>#bookersDetail.firstName#</td>
						<td>#bookersDetail.lastName#</td>
						<td>#bookersDetail.emailAddress#</td>
						<td>#bookersDetail.seatsBooked#</td>
						<td>#bookersDetail.feeChargedInMYR#</td>
					</tr>
				</cfloop>
		</table>
	</div>
</cfoutput>