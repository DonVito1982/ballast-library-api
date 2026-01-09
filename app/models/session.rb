# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Session < ApplicationRecord
  belongs_to :user

  DEFAULT_MINS = 1
end
