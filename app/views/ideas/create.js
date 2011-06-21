/* Insert a notice between the last comment and the comment form */
$j("#idea-notice").html('<div class="flash notice"><%= escape_javascript(flash.delete(:notice)) %></div>');

/* Add the new comment to the bottom of the comments list */
$j("#submitted_ideas").append("<%= escape_javascript(render(@idea)) %>");

/* Highlight the new comment */
$j("#idea_<%= @idea.id %>").effect("highlight", {}, 3000);

/* Reset the comment form */
$j(':input','#new_idea')
 .not(':button, :submit, :reset, :hidden')
 .val('')
 .removeAttr('checked')
 .removeAttr('selected');