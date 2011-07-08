class Message < ActionMailer::Base
  default :from => "info@VotingModule.be"

      def feedback_message(user,mes)
        @user = user
        @mes = mes
        mail(:from => @user.email, :to => "zenon.alex@gmail.com", :subject => "A message from #{@user.displayName}")
      end
end
