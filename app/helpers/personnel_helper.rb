module PersonnelHelper
  
  def see_education(user)
    user.education? && (user.degrees.count > 0)
  end
  
  def see_interests(user)
    (user.role.name != "staff") && user.subpage(:interests)
  end

  def id_for(user, id)
    'id="' + user.username + "_" + id + '"'
  end
end
