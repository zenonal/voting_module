
$j(document).ready(function() {
	$j("[title]").tooltip({
	   
	   delay: 500,
	
	   // tweak the position
	   offset: [-10, 12],

	   // use the "slide" effect
	   effect: 'slide'

	// add dynamic plugin with optional configuration for bottom edge
	}).dynamic({ bottom: { direction: 'down', bounce: true } });
});