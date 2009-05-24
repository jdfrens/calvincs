module PagesHelper
  def page_title(page)
    page.subpage? ? "SUBPAGE identified as #{page.identifier}" : h(page.title)
  end
end
