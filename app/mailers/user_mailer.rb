class UserMailer < ApplicationMailer
    def send_email
        # @user = user
        mail(to: 'noreplyforme2@gmail.com', subject: 'Welcome to My Awesome Site')
    end
end
