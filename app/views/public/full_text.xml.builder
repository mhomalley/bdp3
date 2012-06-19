xml.instruct! :xml, :version => "1.0", :standalone => "yes"
xml.Root do
  
  @type = :full  
  xml << render(:partial => 'full')  
  
  @type = :toc
  xml.contents {
    xml << render(:partial => 'full')      
  }  

end  
