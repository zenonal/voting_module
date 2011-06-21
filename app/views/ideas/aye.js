if ("<%= flash[:notice] %>") {
	$j("#idea-notice").html('<div class="flash notice"><%= escape_javascript(flash.delete(:notice)) %></div>');
} else {
	$j("#idea_<%= @idea.id %> #idea-score").html("<%= @idea.votes_for-@idea.votes_against %>");
	$j("#idea_<%= @idea.id %> #idea-vote-aye a").removeClass("bill_nosupport").addClass("bill_support");
	$j("#idea_<%= @idea.id %> #idea-vote-nay a").removeClass("bill_support").addClass("bill_nosupport");
	$j("#idea-notice").html('');
}