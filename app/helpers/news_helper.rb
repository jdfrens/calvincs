module NewsHelper
  
  def news_item_class(news_item)
    news_item.is_current? ? "current-news" : "past-news"
  end
  
end
