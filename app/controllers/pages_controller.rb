class PagesController < ApplicationController
  
  def homepage
    if params[:neutral]
      @parsed_json = ActiveSupport::JSON.decode(params[:neutral])
    end
  end
  
  def increment_tutorial
    if cookies[:tutorial_active] == "true"
      cookies[:tutorial_index] = cookies[:tutorial_index].to_i+1
      if cookies[:tutorial_index].to_i > cookies[:tutorial_length].to_i
        cookies[:tutorial_index] = 1
      end
      cookies[:tutorial_hposition] = @tutorial_positions[cookies[:tutorial_controller]][cookies[:tutorial_action]]["step#{cookies[:tutorial_index].to_i}"]["left"]
      cookies[:tutorial_vposition] = @tutorial_positions[cookies[:tutorial_controller]][cookies[:tutorial_action]]["step#{cookies[:tutorial_index].to_i}"]["top"]
    end
  end
  
  def send_message
      Message.feedback_message(current_user,params[:message]).deliver
      flash[:notice] = t(:message_sent)
      redirect_to session[:jumpback] 
  end

end
