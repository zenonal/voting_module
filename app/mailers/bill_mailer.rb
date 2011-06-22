class BillMailer < ActionMailer::Base
  default :from => "info@VotingModule.be"
 
    def bill_creation_confirmation(user,bill)
      @user = user
      @bill = bill
      @bill_name = eval("@bill.name_#{I18n.locale}")
      mail(:to => "#{user.displayName} <#{user.email}>", :subject => "#{@bill_name} #{t('mailer.bill_created')}")
    end
end
