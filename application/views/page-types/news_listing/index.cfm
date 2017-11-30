<h2>News List</h2>
<div id="news_list">
<<<<<<< HEAD
<<<<<<< HEAD
	<cfoutput query="#args.newsList#">
=======
	<cfoutput query="args.newsList">
>>>>>>> feature-practice-10-extensions
=======
<<<<<<< Updated upstream
	<cfoutput query="args.newsList">
=======
	<cfoutput query="#args.newsList#">
>>>>>>> Stashed changes
>>>>>>> feature-practice-10-extensions
		<div class="jumbotron">
			<a href="#event.buildLink( linkTo="news/"&args.newsList.news_slug )#">#args.newsList.title#</a>
		</div>
	</cfoutput>
</div>
<cfif NOT args.allNewsLoaded>
	<button class="btn btn-success" id="btnLoadNews">Load More</button>
</cfif>