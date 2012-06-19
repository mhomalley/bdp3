module ArticlesHelper
  def articles_left_menu
    render(:partial => 'menu')
  end

  def articles_right_menu
    render(:partial => 'r_menu')
  end
end
