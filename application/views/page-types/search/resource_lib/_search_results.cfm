<cfscript>
	result = args.searchResult.result?:[];
	previousRecordNumber = ( ( args.currentPage?:0 ) - 1 ) * 10;
</cfscript>
<cfprocessingdirective suppressWhitespace="true">
	<cfoutput>
		<cfloop array="#result#" item="result" index="i">
			<tr>
				<td>#previousRecordNumber + i#</td>
				#renderView(
					  view          = "page-types/search/resource_lib/_resource_type"
					, args          = args
					, presideObject = "resource_library_resource"
					, id            = result.id
				)#
			</tr>
		</cfloop>
	</cfoutput>
</cfprocessingdirective>