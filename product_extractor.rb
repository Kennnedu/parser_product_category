class ProductExtractor
  attr_accessor :id, :page

  def initialize
    @result = {}
  end

  def call(csv)
    csv << @result.values
    @result.clear
  end

  def parse_name
    @result[:name] = name_part_1 + ' ' + name_part_2
  end

  def parse_price
    @result[:price] = @page.xpath(".//ul[@id='product-select-list']/li[@data-product_id ='#{@id}']/span[@class='price']")
                           .text.to_s.strip.slice(1..-1).to_f
  end

  def parse_code
    @result[:code] = @page.xpath(".//div[@class='product_#{@id}_details product_details_list']/span/span").text.to_s.to_i
  end

  def parse_image_url
    img = @page.xpath(".//div[@class='gridbox three-eighths']/div/img[@id='product_image_#{@id}']/@src").to_s
    @result[:image_url] = img.empty? ? without_image_url : img
  end

  def parse_delivery_time
    @result[:delivery_time] =
      @page.xpath(".//div[@class='product_#{@id}_details product_details_list']/div/p[@class='notification_in-stock']")
           .text.to_s.strip
  end

  private

  def name_part_1
    @page.xpath(".//h1[@id='product_family_heading']").text.to_s.strip
  end

  def name_part_2
    @page.search(".//span[@class='clearance_product_label']").remove
    @page.xpath(".//ul[@id='product-select-list']/li[@data-product_id ='#{@id}']/span[@class='name']")
         .text.to_s.strip
  end

  def without_image_url
    @page.xpath(".//img[@id='category_image']/@src").to_s
  end
end
