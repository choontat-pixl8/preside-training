<cf_presideparam name="args.href" field="resource_library_external_link.href" />
<cf_presideparam name="args.type" field="type" />
<cfoutput>
	<a href="#event.buildLink( linkTo="resource-link/"&args.id )#">#args.title#</a>
</cfoutput>