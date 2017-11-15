<cf_presideparam name="args.title"          field="page.title"          editable="true" />
<cf_presideparam name="args.main_content"   field="page.main_content"   editable="true" />
<cf_presideparam name="args.bottom_content" field="page.bottom_content" editable="true" />

<cfset regions = args.regions?:QueryNew("") />

<cfoutput>
	<h1>#args.title#</h1>
	#args.main_content#

	<form method="POST" action="#event.buildLink()#">
		<label>Filter Events By Region</label>
		<div class="input-group">
			<span class="input-group-addon">
				Select Region
			</span>

			<select name="region" class="form-control">
				<option value="">
					All
				</option>
				<cfloop query="regions">
					<option value="#id#" #( rc.region?:"" ) == id ? "selected" : ""#>
						#label#
					</option>
				</cfloop>
			</select>

			<span class="input-group-btn">
				<button class="btn btn-info">
					Filter
				</button>
			</span>
		</div>
	</form>

	#renderView( view="page-types/event_listing/_featured_event", args=args )#

	<h2>All Events:</h2>
	<ul>
		<cfif args.events.recordcount >
			<cfoutput query="#args.events#">
				<li>
					<a href="#event.buildLink( page=args.events.id )#">
						#args.events.title#
					</a>
				</li>
			</cfoutput>
		<cfelse>
			No events available.
		</cfif>
	</ul>

	#args.bottom_content#
</cfoutput>