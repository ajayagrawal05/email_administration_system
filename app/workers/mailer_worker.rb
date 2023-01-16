class MailerWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0
  
    def perform(email_id, user_id)
			@email = Email.find_by(id: email_id)
			@user = User.find_by(id: user_id)

			log = EmailLog.find_or_create_by(email_id: @email.id, user_id: @user.id)
			if log.frequency_count < @email.frequency.to_i
					UserMailer.with(email: @email, user: @user).send_email.deliver_later
					time = Time.now + @email.interval_between.minutes
					sidekiq_id = Sidekiq::Client.enqueue_to_in("default", time , MailerWorker, @email.id, @user.id)
					log.update(sidekiq_id: sidekiq_id, frequency_count: log.frequency_count + 1)
			end
    end
  end