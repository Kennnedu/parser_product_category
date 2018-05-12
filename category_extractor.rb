class CategoryExtractor
  include ParserHelper
  BASE_URL = 'https://www.viovet.co.uk'.freeze
  HEADER_CSV = %w(Name Amount Image DeliveryDate Code).freeze

  def initialize(category_url, filename = 'extracted_data')
    @current_page = save_page(category_url)
    @filename = filename
    @multiproduct_extractor = MultiproductExtractor.new
  end

  def self.call(category_url, filename)
    return unless category_url
    new(category_url, filename).call
  end

  def call
    extract_multiproducts
    return unless exist_next_page?
    @current_page = save_page(extract_next_url)
    call
  end

  private

  def extract_multiproducts
    CSV.open("#{@filename}.csv", 'wb') do |csv|
      csv << HEADER_CSV

      parse_links_multiproducts.each do |links_multiproduct|
        @multiproduct_extractor.page = save_page(links_multiproduct)
        @multiproduct_extractor.call(csv)
      end
    end
  end

  def parse_links_multiproducts
    @current_page.css('a.grid-box').map { |tag| BASE_URL + tag['href'] }
  end

  def exist_next_page?
    @current_page.xpath(".//div[@class='pagination']").to_s.empty?
  end

  def extract_next_url
    BASE_URL + @current_page.xpath(".//div[@class='paging-block infinite_scrolling_enabled']/a/@href").to_s
  end
end
