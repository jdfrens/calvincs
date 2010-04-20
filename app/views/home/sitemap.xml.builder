xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do
  xml.url do
    xml.loc "#{CALVINCS_URL}/"
    xml.priority "0.8"
  end

  ["courses", "events", "newsitems"].each do |component|
    xml.url do
      xml.loc "#{CALVINCS_URL}/#{component}"
    end
  end

  @pages.each do |page|
    xml.url do
      xml.loc "#{CALVINCS_URL}/p/#{page.identifier}"
    end
  end

  @courses.each do |course|
    if course.url =~ %r{^#{CALVINCS_URL}/}
      xml.url do
        xml.loc course.url
      end
    end
  end

  xml.url do
    xml.loc "#{CALVINCS_URL}/people"
  end
  @people.each do |person|
    xml.url do
      xml.loc "#{CALVINCS_URL}/people/#{person.username}"
    end
  end

  ["connect", "blasted"].each do |activity|
    xml.url do
      xml.loc "#{CALVINCS_URL}/activities/#{activity}/"
    end
  end

  ["c++/intro/3e/", "c++/ds/2e/", "fortran/", "java/intro/1e/", "networking/labbook/"].each do |book|
    xml.url do
      xml.loc "#{CALVINCS_URL}/books/#{book}"
    end
  end
end
