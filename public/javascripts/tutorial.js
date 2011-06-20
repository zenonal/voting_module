
$j(document).ready(function() {
	
	$j("#tutorial").expose({loadSpeed: 0});

	$j("body").click(function() {
		// perform exposing for the clicked element
		$j.mask.close();
		$j("#tutorial").hide();
	});
});
