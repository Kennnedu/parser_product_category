class ParserProducts < ApplicationBase
  BASE_URL = 'https://www.viovet.co.uk'.freeze
  HEADER_CSV = %w(Name Amount Image DeliveryDate Code).freeze

  def initialize(category_url, file_name)
    @current_page = save_page(category_url)
    @links_multiproducts = []
    @file_name = file_name
    @products = []
  end

  def parse
    extract_links_multiproducts
    extract_products
    save_products
    return unless exist_next_page?
    @current_page = save_page(extract_next_url)
    parse
  end

  private

  def extract_links_multiproducts
    @links_multiproducts = @current_page.css('a.family-listing__link').map { |tag| BASE_URL + tag['href'] }
  end

  def extract_products
    @links_multiproducts.each do |links_multiproduct|
      @products += Multiproduct.new(links_multiproduct).extract
    end
  end

  def save_products
    CSV.open("#{@file_name}.csv", 'wb') do |csv|
      csv << HEADER_CSV

      @products.each do |product|
        csv << product.attributes
      end
    end
  end

  def exist_next_page?
    @current_page.xpath(".//div[@class='pagination']").to_s.empty?
  end

  def extract_next_url
    BASE_URL + @current_page.xpath(".//div[@class='paging-block infinite_scrolling_enabled']/a/@href").to_s
  end
end
