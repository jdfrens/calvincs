module PagesHelper
  def subtitle_or_not(page)
    page.subpage? ? "SUBPAGE (NO TITLE)" : h(page.title)
  end
end
