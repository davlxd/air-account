class User < ApplicationRecord
  validates :air_auth_token, presence: true, length: { is: 36 }
  enum status: {live: 'LIVE', blocked: 'BLOCKED'}
end
