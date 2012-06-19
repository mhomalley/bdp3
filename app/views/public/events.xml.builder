xml.instruct! :xml, :version => "1.0", :standalone => "yes"
xml.Root do
  unless (foo = @issue.cur_calendars).empty?
    xml.header "Events" 
    xml.calendars do
      for @article in foo do
        xml << render(:partial => 'story_complete')
      end
    end
  end
end  

