<cfoutput>
	<div class="jumbotron">
		<h3>#args.title#</h3>
		<iframe 
			style = "
				width:#args.dimensions.width#;
				height:#args.dimensions.height#
			" 
			src   = "https://www.youtube.com/embed/#args.videoId#">
		</iframe>
	</div>
</cfoutput>