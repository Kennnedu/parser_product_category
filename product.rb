class Product
  attr_reader :product_id, :name, :price, :image_url, :delivery_time, :code
  attr_accessor :product_id, :name, :price, :image_url, :delivery_time, :code

  def attributes
    [@name, @price, @image_url, @delivery_time, @code]
  end
end
