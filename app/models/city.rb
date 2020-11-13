class City < ApplicationRecord
  belongs_to :state

  validates :name, presence: true
  validates_uniqueness_of :name

  def country_name
    state&.country&.name
  end

  def state_name
    state&.name
  end
end
