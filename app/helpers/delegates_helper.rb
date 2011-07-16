module DelegatesHelper
  def delegate_button(delegate_user)
   if user_signed_in?
     unless delegate_user.delegate.nil?
				if current_user.delegation.nil?
					output = link_to(t('users.delegates.choose'), {:controller => :delegations, :action => :create, :delegate_id => delegate_user.delegate.id, :user_id => current_user.id}, :method => :post, :class => "button")
				else
					if current_user.delegation.delegate_id == delegate_user.delegate.id
					  output = "<table><tr><td>"
					  output += t('users.delegates.current_delegate')
					  output += "</td></tr>"
					  output += "<tr><td>"
					  output += link_to t('users.delegates.cancel_delegate'), {:controller => :delegations, :action => :destroy, :id => current_user.delegation.id}, :method => :delete, :class => "button"
					  output += "</td></tr></table>"
					else
					  output = link_to(t('users.delegates.choose'), {:controller => :delegations, :action => :create, :delegate_id => delegate_user.delegate.id, :user_id => current_user.id}, :method => :post, :class => "button")
					end
				end
		 end
	 end
  end
end
