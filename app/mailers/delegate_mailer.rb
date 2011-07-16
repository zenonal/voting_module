class DelegateMailer < ActionMailer::Base
  default :from => "info@VotingModule.be"
  def delegation_forced_cancellation(user,delegate)
        @user = user
        @delegate = delegate
        mail(:to => "#{user.displayName} <#{user.email}>", :subject => "#{@delegate.user.displayName} #{t('mailer.delegation_cancelled')}")
      end
end
