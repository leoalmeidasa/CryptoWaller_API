class MiningType < ApplicationRecord
  has_many :coins
  validates :description, :acronym, presence: true
end
