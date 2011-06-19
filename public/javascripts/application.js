// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var color_options = {colors: ["#9440ed","#4da74d", "#edc240","#afd8f8","#cb4b4b"]};

$j(document).ready(function() {
	$j(".ranking" ).ranking();
	$j('#filter_options').hide();
	$j("#options_toggle").click(function() {
			// perform exposing for the clicked element
			$j('#filter_options').toggle("slow");
		});	
	$j('#pwd_options').hide();	
	$j("#pwd_toggle").click(function() {
			// perform exposing for the clicked element
			$j('#pwd_options').toggle("slow");
		});	
	$j('#bill_translation').hide();
	$j('#translations_hide_container').hide();
	$j('#translations_show').click(function(){
		$j('#bill_translation').show("slow");
		$j('#translations_show_container').hide();
		$j('#translations_hide_container').show();
		});
	$j('#translations_hide').click(function(){
		$j('#bill_translation').hide("slow");
		$j('#translations_show_container').show();
		$j('#translations_hide_container').hide();
		});
	
	$j(".time_chart").each(function(){
		$j.plot($j(this), [parseInt($j('.remaining_time').text()),parseInt($j('.passed_time').text())],
			{
			   colors: ["#4da74d","#a74000"],
			   series: {

			       pie: { 

			           innerRadius: 0.5,
			           show: true     
			            }
			           }
			});
	});
	
	
});
