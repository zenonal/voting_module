// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.clickWithAjax = function() {
  	this.unbind('click', false);
	this.click(function() {
	    $.post($(this).attr("href"), $(this).serialize(), null, "script");
	    return false;
	})
	return this;
};

$(document).ready(function() {
	$("[title]").tooltip({
			effect: 'fade',
			fadeOutSpeed: 100,
			predelay: 1200});
	$("ul.tabs").tabs("div.panes > div");
	$(".scrollable").scrollable();
	$(".tooltip_class").tooltip({
			effect: 'fade',
			fadeOutSpeed: 100,
			predelay: 400,
			delay: 1000,
			position: "top center"});
});
