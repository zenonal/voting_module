class Message < ActionMailer::Base
  default :from => "info@jegouverne.be"

      def feedback_message(user,mes)
        if user.nil?
                @mes = mes
                mail(:from => "unsigned_user@votingModule.be", :to => "zenon.alex@gmail.com", :subject => "A message from an unsigned user")
        else
                @user = user
                @mes = mes
                mail(:from => @user.email, :to => "zenon.alex@gmail.com", :subject => "A message from #{@user.displayName}")
        end
      end
end
