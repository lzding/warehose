class Fortlift < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :delivery
  has_many :state_logs, as: :stateable
end
