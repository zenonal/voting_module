module DelegatesHelper
  def delegate_button(delegate_user)
     unless delegate_user.delegate.nil?
				if current_user.delegation.nil?
					output = button_to t('users.delegates.choose'), {:controller => :delegations, :action => :create, :delegate_id => delegate_user.delegate.id, :user_id => current_user.id} 
				else
					if current_user.delegation.delegate_id == delegate_user.delegate.id
					  output = "<table><tr><td>"
					  output += t('users.delegates.current_delegate')
					  output += "</td></tr>"
					  output += "<tr><td>"
					  output += button_to t('users.delegates.cancel_delegate'), delegation_path(current_user.delegation), {:method => :delete}
					  output += "</td></tr></table>"
					else
					  output = button_to t('users.delegates.choose'), {:controller => :delegations, :action => :create, :delegate_id => delegate_user.delegate.id, :user_id => current_user.id}
					end
				end
		 end
  end
end
