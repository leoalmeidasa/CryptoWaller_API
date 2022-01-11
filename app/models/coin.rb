class Coin < ApplicationRecord
  belongs_to :mining_type
  validates_presence_of :description, :acronym, presence: true
  validates_associated :mining_type
end
