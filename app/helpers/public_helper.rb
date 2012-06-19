module PublicHelper
  #Helpers from BDP
  
  #Returns nil or text  (with a <i></i>)
  def article_author(article)
    unless article.author.nil?
      content_tag('i', article.author)
    end
  end

  #Returns "date" text (with a <i></i>)
  def article_post_date(article)
    if article.posted_at.nil?
      content = article.issue.date.strftime("%A %B %d, %Y")      
    else
      content = article.posted_at.strftime("%A %B %d, %Y - %r") #{#Justin} at %H:%M")
    end
    content_tag('i', content)
  end


  #Returns short "date" text (with a <i></i>)
  def article_short_post_date(article)
    if article.posted_at.nil?
      content = article.issue.date.strftime("%m-%d-%Y")      
    else
      content = article.posted_at.strftime("%m-%d-%Y")
    end
    content_tag('i', content)
  end

  #Returns nil or text (with a span of class .red or .green sometimes)
  def article_headline(article)
    unless article.headline.nil?
      if article.in_flash_section?
        headline = content_tag('span', "Flash: #{article.headline}", :class => 'red')
      elsif article.in_new_section?
        headline = content_tag('span', "New: ", :class => 'green') + article.headline
      elsif article.in_updated_section?
        headline = content_tag('span', "Updated: ", :class => 'orange') + article.headline
      elsif article.in_press_section?
        headline = content_tag('span', "Press Release: ", :class => 'gray') + article.headline
      else
        headline = article.headline
      end
      if article.author.nil?
        #
        link_to(headline, public_article_path(:issue_id => d(article.issue.date), :storyID => article, :headline => headline_to_url(article.headline)))
      else
        link_to(headline, public_article_path(:issue_id => d(article.issue.date), :storyID => article, :headline => headline_to_url(article.headline + "--" + article.author)))
      end
    end
  end

  #Returns nil or text  (with a <p class=red></p>)
  def archive_notice
    if d(@issue.date) < d(PubDate.latest.date)  #MHO sb < & use real dates
      content_tag('p', 'You are in the archives.', :class => 'red cntr')
    end
  end

  def editorial_cartoon_link
    url_path = File.join('/', 'cartoons', "#{ds(@issue.date)}-justin-defreitas.jpg")
    file_path = File.join(RAILS_ROOT, 'public', url_path)
    if File.exists?(file_path)
      link_to('Editorial Cartoon', url_path)
    end
  end

  def editorial_cartoon_img  # try_ only
    url_path = File.join('/', 'cartoons', "#{ds(@issue.date)}-justin-defreitas.jpg")
    file_path = File.join(RAILS_ROOT, 'public', url_path)
    if File.exists?(file_path)
      content_tag('div', link_to(tag('img', :src => url_path), url_path, :target => '_blank'), :class => 'photo_ec')
      #content_tag('div', link_to(tag('img', :src => url_path), "#{url_path}\"target='_blank'"), :class => 'photo_ec')
      #content_tag('div', link_to(tag('img', :src => url_path), '##top'), :class => 'photo_ec')
    end
  end

  def section_article_link(name, section)
    unless @issue.send(section).nil?
      link_to(name, public_article_path(:issue_id => d(@issue.date), :storyID => @issue.send(section)))
    end
  end
end
