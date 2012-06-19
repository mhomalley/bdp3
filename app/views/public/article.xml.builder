xml.instruct! :xml, :version => "1.0", :standalone => "yes"
xml.Root do
  xml.section do
    xml.header "#{cat_text(@article.priority)}:"
    xml << render(:partial => 'story_complete')
  end
end  
