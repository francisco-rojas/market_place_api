class Order < ActiveRecord::Base
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  validates :user_id, presence: true
  before_validation :set_total!
  validates_with EnoughProductsValidator

  def set_total!
    self.total = placements.inject(0) do |sum, placement|
      sum += placement.product.price * placement.quantity
      sum
    end
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |id, quantity|
      self.placements.build(product_id: id, quantity: quantity)
    end
  end
end
