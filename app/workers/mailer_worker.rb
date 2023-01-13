class MailerWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0
  
    def perform(email_id, user_id)
			@email = Email.find_by(id: email_id)
			@user = User.find_by(id: user_id)

			log = EmailLog.where(email_id: @email.id, user_id: @user.id)
			if log.frequency_count < @email.frequency 
					time = Time.now + @email.interval_between.days
					count += 1
					sidekiq_id = Sidekiq::Client.enqueue_to_in("default", time , MailerWorker, @email.id, @user.id)
					log.update(sidekiq_id: sidekiq_id, frequency_count: count)
			end
    end
  end