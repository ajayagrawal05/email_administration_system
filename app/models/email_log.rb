class EmailLog < ApplicationRecord
    belongs_to :user
    belongs_to :email
end