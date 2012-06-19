if @type == :toc
  #xml.toc_headline @article.headline.gsub(/\n/m, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "")
  xml.toc_headline "#{@article.author.gsub(/\n/m, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "").gsub(/By /, "")}: #{@article.headline.gsub(/\n/m, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "")}"
  #xml.toc_author @article.author.gsub(/\n/m, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "").gsub(/By /, "")
else
  xml.headline @article.headline.gsub(/\n/m, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "")
  xml.author @article.author.gsub(/\n/m, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "")
  #end
  #unless @type == :toc
  xml.date @article.posted_at
  for image in @article.images do
    xml.image {
      xml.Photo(:href => "file:///#{image.issue.date.strftime('%m-%d-%y')}/#{bdp_escape(image.file_name)}")
      #xml.Photo(:href => "file:///Users/michaelomalley/apps/bdp/public/photos/#{image.issue.date.strftime('%m-%d-%y')}/#{bdp_escape(image.file_name)}")
      #xml.Photo(:href => "http://berkeleydailyplanet.com/photos/#{image.issue.date.strftime('%m-%d-%y')}/#{bdp_escape(image.file_name)}")
      unless image.author.empty? 
        xml.photographer image.author.gsub(/\n/, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "") 
      end
      unless image.caption.empty? 
        xml.caption image.caption.gsub(/\n/, " ").gsub(/^[ \t]*/, "").gsub(/[ \t]*$/, "")
      end
    }
  end
  xml.copy @article.copy.gsub(/^[ \t]*/, "").gsub(/\r?\n[ \t]*\r?\n/m, "\n") unless @article.copy.empty?
end