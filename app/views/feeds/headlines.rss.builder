xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    #xml.link formatted_feeds_action_url(:format => 'rss', :action => 'full')
    xml.title "The Berkeley Daily Planet, The East Bay's Independent Newspaper"
    xml.description "Full coverage of local news and opinion from Berkeley and the surrounding cities."
    xml.link empty_url
    #MHO xml.pubDate PubDate.latest.date.to_s(:rfc822)
    xml.category "Newspapers"
    xml.ttl 60

    for article in @articles
      if (article.priority > -200) && (article.priority < 200)
        xml.item do
          xml.title article.headline
          ##MHO xml.description article.preview
          xml.pubDate article.posted_at.to_s(:rfc822)
          xml.author article.author
          xml.link public_article_url(:issue_id => d(article.issue.date),
           :storyID => article, :headline => headline_to_url(article.headline)) # unless article.headline.nil?
          xml.guid public_article_url(:issue_id => d(article.issue.date),
           :storyID => article, :headline => headline_to_url(article.headline)) # unless article.headline.nil?
        end
      end
    end
  end
end
