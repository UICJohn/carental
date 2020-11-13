class City < ApplicationRecord
  belongs_to :state

  validates :name, presence: true
  validates :name, uniqueness: true

  def country_name
    state&.country&.name
  end

  def state_name
    state&.name
  end
end
