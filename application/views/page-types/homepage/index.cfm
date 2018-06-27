<cfparam name="args.title"          type="string" field="page.title"          editable="true" />
<cfparam name="args.bottom_content" type="string" field="page.bottom_content" editable="true" />
<cfparam name="args.main_content"   type="string" field="page.main_content"   editable="true" />

<cfoutput>
	#renderView( view="page-types/search/_search_field", args=args )#
	<div class="jumbotron">
		<h1>#args.title#</h1>
	</div>
	#args.main_content#
	<br/>
	#args.bottom_content#
</cfoutput>