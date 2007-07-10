module PersonnelHelper
  
  def see_education(user)
    user.education? && (user.degrees.size > 0 || current_user)
  end
  
  def see_interests(user)
    user.group.name != "staff" && (user.subpage(:interests) || current_user)
  end

  def id_for(user, id)
    'id="' + user.username + "_" + id + '"'
  end
  
end
