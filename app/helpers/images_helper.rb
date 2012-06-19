module ImagesHelper
  
  def images_left_menu
    if @image.nil?
      ''
    else
      render(:partial => 'menu')
    end
  end

  def images_right_menu
    render(:partial => 'r_menu')
  end

end
