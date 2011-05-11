// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

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
	$(".argument_table").hide();
	$(".argument_title").hover(function(){
		$(this).css('cursor','pointer');
	});
	$(".argument_title").click(function(){
	// slide toggle effect set to slow you can set it to fast too.
	$(this).next(".argument_table").slideToggle("slow");
	return true;});
	$(".new_argument").submitWithAjax();
	$('a.remote-delete').clickWithAjax();
	$('a.remote-disagree').clickWithAjax();
	$('a.remote-agree').clickWithAjax();
});
