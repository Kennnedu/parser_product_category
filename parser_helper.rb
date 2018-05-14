module ParserHelper
  def save_page(url)
    html = open(url, &:read)
    Nokogiri::HTML(html)
  end
end
