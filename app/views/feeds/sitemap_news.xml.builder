xml.instruct! :xml, :version => "1.0" 
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9',
'xmlns:news' => 'http://www.google.com/schemas/sitemap-news/0.9' do
  for article in @articles do
    if (article.priority > -200) && (article.priority < 200)
      xml.url do
        xml.loc public_article_url(:issue_id => d(article.issue.date),
         :storyID => article, :headline => headline_to_url(article.headline)) # unless article.headline.nil?
        xml.news :news do
          xml.news :publication_date, article.posted_at.xmlschema
          xml.news :keywords, g_keywords(article.priority)
        end   
      end
    end
  end
  #home sales
  #open houses
  #local sales
end
  
