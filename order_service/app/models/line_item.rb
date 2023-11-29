class LineItem < ApplicationRecord
  belongs_to :order

  after_save :update_total_price
  after_destroy :update_total_price

  def update_total_price
    updated_total_price = self.order.line_items.sum { |line_item| line_item.price * line_item.quantity }
    self.order.update(total_price: updated_total_price)
  end
end
