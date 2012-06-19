xml.instruct! :xml, :version => "1.0", :standalone => "yes"
xml.Root do
  xml.section do
    for @article in @articles
      xml << render(:partial => 'public/story_complete')
    end
  end
end  
