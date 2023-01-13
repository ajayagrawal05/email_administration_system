class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails do |t|
      t.string :name
      t.string :subject
      t.string :type
      t.integer :interval_between
      t.integer :frequency
      t.text :body

      t.timestamps
    end
  end
end
