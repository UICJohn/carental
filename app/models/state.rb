class State < ApplicationRecord
  belongs_to :country

  validates :name, presence: true
  validates :name, uniqueness: true
end
