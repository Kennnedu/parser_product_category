class ExtractionProducts < ApplicationBase
  attr_reader :products

  def initialize(url)
    @products = []
    @doc = save_page(url)
  end

  def extract
    product_id
    @products.each do |product|
      save_params(product)
    end
  end

  private

  def save_params(product)
    product.name = name_part_1 + ' - ' + name_part_2(product.product_id)
    product.price = price(product.product_id)
    product.code = code(product.product_id)
    product.image_url = 'https:' + image_url(product.product_id)
    product.delivery_time = delivery_time(product.product_id)
  end

  def product_id
    @doc.xpath(".//ul[@id='product-select-list']/li/@data-product_id").each do |id|
      product = Product.new
      product.product_id = id.to_s.to_i
      @products << product
    end
  end

  def name_part_1
    @doc.xpath(".//h1[@id='product_family_heading']").text.to_s.strip
  end

  def name_part_2(id)
    @doc.search(".//span[@class='clearance_product_label']").remove
    @doc.xpath(".//ul[@id='product-select-list']/li[@data-product_id ='#{id}']/span[@class='name']")
      .text.to_s.strip
  end

  def price(id)
    @doc.xpath(".//ul[@id='product-select-list']/li[@data-product_id ='#{id}']/span[@class='price']")
      .text.to_s.strip.slice(1..-1).to_f
  end

  def code(id)
    @doc.xpath(".//div[@class='product_#{id}_details product_details_list']/span/span").text.to_s.to_i
  end

  def image_url(id)
    img = @doc.xpath(".//div[@class='gridbox three-eighths']/div/img[@id='product_image_#{id}']/@src").to_s
    return without_image_url if img.empty?
    img
  end

  def without_image_url
    @doc.xpath(".//img[@id='category_image']/@src").to_s
  end

  def delivery_time(id)
    @doc.xpath(".//div[@class='product_#{id}_details product_details_list']/div/p[@class='notification_in-stock']")
        .text.to_s.strip
  end
end
