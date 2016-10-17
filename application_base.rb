class ApplicationBase
  def save_page(url)
    html = open(url)
    Nokogiri::HTML(html)
  end
end
