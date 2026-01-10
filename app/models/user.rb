# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  role            :integer          not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password
  validates :username, uniqueness: true
  enum :role, [ :librarian, :member ]

  has_many :sessions, dependent: :destroy
  has_many :book_borrows

  def alive_sessions
    sessions.where("expires_at > ?", Time.now)
  end

  def close_live_sessions
    alive_sessions.update_all(expires_at: Time.now)
  end

  def create_fresh_session
    close_live_sessions
    sessions.create(expires_at: Time.now + Session::DEFAULT_MINS.minutes)
  end
end
