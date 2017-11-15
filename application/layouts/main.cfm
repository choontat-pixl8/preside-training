<cfscript>
	body     = renderView();
	mainNav  = renderViewlet( "core.navigation.mainNavigation" );
	metaTags = renderView( "/general/_pageMetaForHtmlHead" );
	adminBar = renderView( "/general/_adminToolbar"        );

	event.include( "css-bootstrap" )
	     .include( "css-layout"    )
	     .include( "js-bootstrap"  )
	     .include( "js-validator"  )
	     .include( "js-jquery"     );

	addThisPublicId = getSystemSetting( category="addthis", setting="publicId" )
</cfscript>

<cfoutput><!DOCTYPE html>
<html>
	<head>
		#metaTags#

		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		#event.renderIncludes( "css" )#

		<!--[if lt IE 9]>
			<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
	</head>
	<body>
		<div class="container">
			<div class="header">
				<ul class="nav nav-pills pull-right">
					#mainNav#
				</ul>
				<h3 class="text-muted"><a href="/">Preside CMS</a></h3>
			</div>

			#body#

			<div class="footer">
				<p>&copy; Pixl8 2013-#Year( Now() )#</p>
			</div>
		</div>

		#adminBar#

		#event.renderIncludes( "js" )#
		<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js##pubid=#addThisPublicId#" defer></script>
	</body>
</html></cfoutput>