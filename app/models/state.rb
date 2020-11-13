class State < ApplicationRecord
  belongs_to :country

  validates :name, presence: true
  validates_uniqueness_of :name
end
