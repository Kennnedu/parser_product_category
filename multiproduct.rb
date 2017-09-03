class Multiproduct < ApplicationBase
  attr_reader :products

  def initialize(multiproduct_url)
    @multiproduct_page = save_page(multiproduct_url)
    @products = []
  end

  def extract
    extract_products
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

  def extract_products
    @multiproduct_page.xpath(".//ul[@id='product-select-list']/li/@data-product_id").each do |id|
      product = Product.new
      product.product_id = id.to_s.to_i
      @products << product
    end
  end

  def name_part_1
    @multiproduct_page.xpath(".//h1[@id='product_family_heading']").text.to_s.strip
  end

  def name_part_2(id)
    @multiproduct_page.search(".//span[@class='clearance_product_label']").remove
    @multiproduct_page.xpath(".//ul[@id='product-select-list']/li[@data-product_id ='#{id}']/span[@class='name']")
                      .text.to_s.strip
  end

  def price(id)
    @multiproduct_page.xpath(".//ul[@id='product-select-list']/li[@data-product_id ='#{id}']/span[@class='price']").text
                      .to_s.strip.slice(1..-1).to_f
  end

  def code(id)
    @multiproduct_page.xpath(".//div[@class='product_#{id}_details product_details_list']/span/span").text.to_s.to_i
  end

  def image_url(id)
    img = @multiproduct_page.xpath(".//div[@class='gridbox three-eighths']/div/img[@id='product_image_#{id}']/@src").to_s
    return without_image_url if img.empty?
    img
  end

  def without_image_url
    @multiproduct_page.xpath(".//img[@id='category_image']/@src").to_s
  end

  def delivery_time(id)
    @multiproduct_page
      .xpath(".//div[@class='product_#{id}_details product_details_list']/div/p[@class='notification_in-stock']")
      .text.to_s.strip
  end
end
