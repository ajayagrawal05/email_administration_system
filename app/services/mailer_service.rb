class MailerService
    attr_reader :email_id, :user_id
  
    def initialize(email_id, user_id)
      @email = Email.find_by(id: email_id)
      @user = User.find_by(id: user_id)
    end
  
    def process!
      if @email.email_type == "Transaction"
        send_email
      elsif @email.email_type == "Reminder"
        schedule_reminder
      end
    end

    def send_email
        UserMailer.with(email: @email, user: @user).send_email.deliver_later
    end

    def schedule_reminder
        log = EmailLog.where(email_id: @email.id, user_id: @user.id)
        if log.frequency_count < @email.frequency 
            time = Time.now + @email.interval_between.days
            count += 1
            sidekiq_id = Sidekiq::Client.enqueue_to_in("default", time , MailerWorker, @email.id, @user.id)
            log.update(sidekiq_id: sidekiq_id, frequency_count: count)
        end
    end
  end
  