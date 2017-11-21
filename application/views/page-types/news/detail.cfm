<cfscript>
	newsDetail   = args.newsDetail         ?: {};
	newsTitle    = newsDetail.title        ?: "News Not Found";
	newsContent  = newsDetail.content      ?: "";
	lastModified = newsDetail.datemodified ?: "";
</cfscript>
<cfoutput>
	<h2>#newsTitle#</h2>

	<h3>#dateTimeFormat( lastModified, "yyyy-mm-dd HH:nn" )#</h3>
	
	<p>#newsContent#</p>
</cfoutput>