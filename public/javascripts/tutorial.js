
$j(document).ready(function() {
	$j("#tutorial").expose({loadSpeed: 0});
	$j("#tutorial").click(function() {

			// perform exposing for the clicked element
			$j.mask.close();
		});
});
