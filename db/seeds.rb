5.times do
  user = FactoryGirl.create(:user)
  p ("Populating #{user.email}")

  3.times do
    order = FactoryGirl.build :order, user: user

    product_1 = FactoryGirl.create :product, price: 100, quantity: 5, user: user
    product_2 = FactoryGirl.create :product, price: 85, quantity: 10, user: user

    placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
    placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 2

    order.placemoents << placement_1
    order.placements << placement_2
    order.save!
    p ("Created order #{order.id} for user #{user.email}")
  end
end