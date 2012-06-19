
  unless (foo = @issue.cur_editorials_recent).empty?
    xml.header "Editorial" unless @type == :toc
    xml.editorials {
      for @article in foo do
        xml << render(:partial => 'story_complete')
      end
    }
  end
  
  unless (foo = @issue.new_editorials_recent).empty?
    xml.header "Editor's Back Fence" unless @type == :toc
    xml.ed_back_fence {
      for @article in foo do
        xml << render(:partial => 'story_complete')
      end
    }
  end
  
  xml.header "News" unless @type == :toc
  xml.news {
    for @article in @issue.news_recent do
      xml << render(:partial => 'story_complete')
    end
  }
    
  unless (foo = @issue.commentary_recent).empty?
    xml.header "Opinion" unless @type == :toc 
    xml.opinion {
      for @article in foo do
        xml << render(:partial => 'story_complete')
      end
    }
  end
    
  unless (foo = @issue.ed_cartoons_recent).empty?
    xml.header "Cartoons" unless @type == :toc 
    xml.ed_cartoon {
      for @article in foo do
        xml << render(:partial => 'story_complete')
      end
    }
  end
  
  unless (foo = @issue.columnists_recent).empty?
    xml.header "Columnists" unless @type == :toc 
    xml.columns {
      for @article in foo do
        xml << render(:partial => 'story_complete')
      end
    }
  end
  
  unless (foo = @issue.arts_entertainment_recent).empty?
    xml.header "Arts & Entertainment" unless @type == :toc 
    xml.arts_entertainment {
      for @article in foo do
        xml << render(:partial => 'story_complete')
      end
    }
  end
  
