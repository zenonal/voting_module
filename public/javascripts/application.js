// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var color_options = {colors: ["#9440ed","#4da74d", "#edc240","#afd8f8","#cb4b4b"]};

$j(document).ready(function() {
	$j(".ranking" ).ranking();
	$j('#filter_options').hide();
	$j("#options_toggle").click(function() {
			// perform exposing for the clicked element
			$j('#filter_options').toggle();
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
		$j('#translations_hide_container').show("slow");
		});
	$j('#translations_hide').click(function(){
		$j('#bill_translation').hide("slow");
		$j('#translations_show_container').show("slow");
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
	
	$j("#feedbackForm").hide();
	$j("#feedback").hover(
		function() {
			$j("#feedbackForm").show();
		},
		function() {
			$j("#feedbackForm").hide();
		}
	);
	
	var active_color = '#000'; // Colour of user provided text
	var inactive_color = '#aaa'; // Colour of default text
	$j("#search").css("color", inactive_color);
	var default_values = new Array();
	$j("#search").focus(function() {
	    if (!default_values[this.id]) {
	      default_values[this.id] = this.value;
	    }
	    if (this.value == default_values[this.id]) {
	      this.value = '';
	      this.style.color = active_color;
	    }
	    $j(this).blur(function() {
	      if (this.value == '') {
	        this.style.color = inactive_color;
	        this.value = default_values[this.id];
	      }
	    });
	});
	
	$j("#overlay-intro").overlay({
		top: 200,
		left: 400,
		mask: {
			color: '#fff',
			loadSpeed: 200,
			opacity: 0.9
		},
		closeOnClick: false,
		load: true,
		fixed: false
	});
	
	$j("#overlay-intro form").submit(function(e) {
		var check = $j("input#show_intro_check", this).is(':checked');
		if (check) {
			$j.cookie('show_intro', false);
		} else {
			$j.cookie('show_intro', true);
		}
		return e.preventDefault();
	});
	
	
});
