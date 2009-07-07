module UserHelpers
  def user_session(privilege)
    case privilege
      when :edit
        { :current_user_id => users(:jeremy).id }
      else
        raise "#{privilege.to_s} is an unrecognized privilege"
    end
  end

  def mock_user_session(privilege)
    case privilege
      when :edit
        editor = mock_model(User)
        User.stub!(:find).with(editor.id, anything()).and_return(editor)
        editor.stub!(:has_privilege?).with(:edit).and_return(true)
        { :current_user_id => editor.id }
      else
        raise "#{privilege.to_s} is an unrecognized privilege"
    end
  end
end
