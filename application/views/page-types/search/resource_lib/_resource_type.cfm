<cf_presideparam name="args.id"           field="resource_library_resource.id" />
<cf_presideparam name="args.resourceType" field="resource_type" />
<cf_presideparam name="args.restriction"  field="access_restriction" />
<cf_presideparam name="args.title"        field="resource_library_resource.title" />
<cf_presideparam name="args.resourceId"   field="resource_library_resource.resource_id" />

<cfoutput>
	<td>
		<cfif args.resourceType=="External resource">
			#renderView(
				  view          = "page-types/search/resource_lib/_external_link"
				, args          = args
				, presideObject = "resource_library_external_link"
				, id            = args.resourceId
			)#
		<cfelseif args.resourceType=="Document">
			<a href="#event.buildLink( assetId=args.resourceId )#">#args.title#</a>
		<cfelse>
			<a href="#event.buildLink( page=args.resourceId )#">#args.title#</a>
		</cfif>

		<cfif args.restriction=="full">
			<label class="label label-danger">Restricted</label>
		<cfelseif args.restriction=="partial">
			<label class="label label-warning">Partially Restricted</label>
		</cfif>
	</td>
	<td>#args.resourceType#</td>
</cfoutput>
