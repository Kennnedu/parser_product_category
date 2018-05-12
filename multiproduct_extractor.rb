class MultiproductExtractor
  def initialize
    @product_extractor = ProductExtractor.new
  end

  def call(csv)
    @page.xpath(".//ul[@id='product-select-list']/li/@data-product_id").each do |id|
      @product_extractor.id = id.to_s.to_i
      @product_extractor.parse_name
      @product_extractor.parse_price
      @product_extractor.parse_image_url
      @product_extractor.parse_code
      @product_extractor.parse_delivery_time
      @product_extractor.call(csv)
    end
  end

  def page=(page)
    @page = page
    @product_extractor.page = page
  end
end
