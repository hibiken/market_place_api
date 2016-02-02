class Product < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :price, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
end
