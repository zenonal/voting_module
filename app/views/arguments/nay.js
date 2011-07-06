$j('#bill-score').html('<%= pluralize(@argument.tally_all_votes,t("initiatives.votes")) %><% unless @argument.percent_approval.nan? %>	, <%= @argument.percent_approval.to_i %>% <%= t("initiatives.approval") %>	<%= raw score_meter(@argument.percent_approval/100.0,120) %><% end %>');
$j('.aye').removeClass('bill_support');
$j('.aye').addClass('bill_nosupport');
$j('.nay').removeClass('bill_nosupport');
$j('.nay').addClass('bill_support');