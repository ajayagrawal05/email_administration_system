class CreateEmailLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :email_logs do |t|
      t.integer :email_id
      t.integer :user_id
      t.string :sidekiq_id
      t.integer :frequency_count, default: 0
      t.timestamps
    end
  end
end
