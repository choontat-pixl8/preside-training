<cfprocessingdirective suppressWhitespace="true">
	<cfscript>
		result = args.searchResult.result?:[];
		previousRecordNumber = ( ( args.currentPage?:0 ) - 1 ) * 10;
	</cfscript>

	<cfoutput>
		<cfloop array="#result#" item="result" index="i">
			<tr>
				<td>#previousRecordNumber + i#</td>
				<cfif result.type EQ "resource_library_resource">
					#renderView(
						  view          = "page-types/search/resource_lib/_resource_type"
						, args          = args
						, presideObject = "resource_library_resource"
						, id            = result.id
					)#
				<cfelse>
					<td>
						<a href="#event.buildLink( page=result.id )#">#result.title#</a>
					</td>
					<td>#result.category.len() GT 0 ? result.category : "Others"#</td>
				</cfif>
			</tr>
		</cfloop>
	</cfoutput>
</cfprocessingdirective>