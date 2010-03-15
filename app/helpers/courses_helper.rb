module CoursesHelper
  def link_to_online_materials(course)
    if course.url.blank?
      course.full_title
    else
      link_to(course.identifier, course.url) + ": " + course.title
    end
  end
end
