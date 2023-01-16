class MailerService
    attr_reader :email_id, :user_id
  
    def initialize(email_id, user_id)
      @email = Email.find_by(id: email_id)
      @user = User.find_by(id: user_id)
    end
  
    def deliver!
      UserMailer.with(email: @email, user: @user).send_email.deliver_later
    end
  end
  