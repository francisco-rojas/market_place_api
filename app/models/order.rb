class Order < ActiveRecord::Base
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  validates :user_id, presence: true
  before_validation :set_total!

  def set_total!
    # self.total = products.inject(0) { |sum, product| sum + product.price }
    self.total = products.map(&:price).sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |id, quantity|
      self.placements.build(product_id: id, quantity: quantity)
    end
  end
end
