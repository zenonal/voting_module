$j('#bill-score').html('<%= pluralize(@argument.tally_all_votes,t("initiatives.votes")) %><% unless @argument.percent_approval.nan? %>	, <%= @argument.percent_approval.to_i %>% <%= t("initiatives.approval") %>	<%= raw score_meter(@argument.percent_approval/100.0,120) %><% end %>');
$j('.aye').removeClass('bill_nosupport');
$j('.aye').addClass('bill_support');
$j('.nay').removeClass('bill_support');
$j('.nay').addClass('bill_nosupport');