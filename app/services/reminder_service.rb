class ReminderService
    attr_reader :email_id, :user_id
  
    def initialize(email_id, user_id)
      @email = Email.find_by(id: email_id)
      @user = User.find_by(id: user_id)
    end
  
    def start!
			return unless @email.email_type == "Reminder"
			log = EmailLog.find_or_create_by(email_id: @email.id, user_id: @user.id)
			if log.frequency_count < @email.frequency.to_i
					UserMailer.with(email: @email, user: @user).send_email.deliver_later
					time = Time.now + @email.interval_between.minutes
					sidekiq_id = Sidekiq::Client.enqueue_to_in("default", time , MailerWorker, @email.id, @user.id)
					log.update(sidekiq_id: sidekiq_id, frequency_count: log.frequency_count + 1)
			end
    end

    def stop!
			log = EmailLog.find_by(email_id: @email.id, user_id: @user.id)
			return if (log.blank? || @email.email_type == "Transaction")
			if log.sidekiq_id.present?
				scheduled = Sidekiq::ScheduledSet.new
				scheduled.find_job(log.sidekiq_id).try(:delete)
				log.update(sidekiq_id: nil)
			end
    end
  end
  