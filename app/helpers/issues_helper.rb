module IssuesHelper
  def issues_left_menu
    if controller.action_name == 'index'
      render(:partial => 'index_menu')
    else
      render(:partial => 'articles/menu')
    end
  end
end
