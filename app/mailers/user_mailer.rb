class UserMailer < ApplicationMailer
    def send_email
        @user = params[:user]
        @email = params[:email]
        mail(to: @user.email, subject: @email.subject)
    end
end
