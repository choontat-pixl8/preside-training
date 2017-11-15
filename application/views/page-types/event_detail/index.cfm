<cf_presideparam name="args.title"          field="page.title"            editable="true" />
<cf_presideparam name="args.main_content"   field="page.main_content"     editable="true" />
<cf_presideparam name="args.bottom_content" field="page.bottom_content"   editable="true" />
<cf_presideparam name="args.parent"         field="page.parent_page"                      />
<cf_presideparam name="args.eventPageId"    field="event_detail.id"                       />
<cf_presideparam name="args.documentId"     field="event_detail.document"                 />

<cfset disqusPublicId = getSystemSetting( category="disqus", setting="shortname" )?:"" />
<cfset documentURL    = event.buildLink( assetId=args.documentId?:"" )                 />
<cfset previewMode    = rc.previewDocument?:"false"                                    />

<cfoutput>
	<h1>#args.title#</h1>
	#args.main_content#

	#args.bottom_content#

	#renderViewlet( event="page-types.event_detail._relatedEvents", args=args )#
	#renderViewlet( event="page-types.event_detail._programmes"   , args=args )#

	<cfif args.isEventExpired >
		<cfif len ( args.documentId ) >
				<a href="#documentURL#">
					#renderAsset( assetId=args.documentId )#
					Download 
					#args.event.documentTitle#
				</a>

				<BR/><BR/>

				<img src="#event.buildLink( assetId=args.documentId, derivative="pdfPreview")#" alt="#args.event.documentTitle#" />

		</cfif>

		<div id="disqus_thread"></div>

		<script src="https://#disqusPublicId#.disqus.com/embed.js" data-timestamp="#getTickCount()#" defer></script>

	<cfelseif args.isEventBookeable>
		<cfif args.seatFullyBooked>
			<div class="alert alert-info">Seat fully booked.</div>
		<cfelse>
			<a 
				class="btn btn-success"
				href="#event.buildLink( page="event_booking" ,querystring="eventId=#event.getCurrentPageId()#")#">
					Book now!
			</a>
		</cfif>
		
	</cfif>

</cfoutput>