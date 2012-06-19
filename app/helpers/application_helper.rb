# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #HAML for staticmatic helper stylesheets
  #def stylesheets
  #  stylesheet_link_tag "public", :media => "all"
  #  ##javascript_include_tag('application')
  #end

  #CF to Rails include file
  def partial_include(bar)
    render :partial => "#{bar}"
  end

  # include file in views/public with extension .haml or rhtml
  def file_include(bar)
    render :file => "public/#{bar}"
  end

  #Fool_spam defn for hiding e-mail
  def fool_spam(name, site = "berkeleydailyplanet.com")
    mail_to("#{name}@#{site}", "#{name} at #{site}",
      ##MHO:subject => "Comments on new web site",
      :encode => "javascript")
  end

  ##def fool_spam(person = 'foobar', host = 'berkeleydailyplanet.com')
  ##  javascript_tag("kill_spam('#{person}', '#{host}')")
  ##end

  #def issue_arg
  #  "?issue=#{ds(@issue.date)}"
  #end
  
  def fix_text(arg)
    raw(arg)
  end

  MO = {
      '01' => 'Jan' ,
      '02' => 'Feb' ,
      '03' => 'Mar' ,
      '04' => 'Apr' ,
      '05' => 'May' ,
      '06' => 'Jun' ,
      '07' => 'Jul',
      '08' => 'Aug',
      '09' => 'Sep',
      '10' => 'Oct',
      '11' => 'Nov',
      '12' => 'Dec'
    }

  def mo2name(mo)
    #debugger
    MO[mo]
  end
  
  def previous_issue
    unless @issue.prev.nil?
      content_tag('li', link_to('Previous Issue', public_issue_path(:issue_id => d(@issue.prev.date))))
    end
  end

  def next_issue
    unless @issue.next.nil? # 5/10 see the un published issue || (@issue.next.date > PubDate.latest.date)
      content_tag('li', link_to('Next Issue', public_issue_path(:issue_id => d(@issue.next.date))))
    end
  end

  def pdf_link(name, section = "")
    #debugger
    if section != ""
      section = "#{section}-"
    end
    path = "/pdfs/#{section}#{ds(@issue.date)}.pdf"
    if File.exists?(Rails.root.join('public', path))
      link_to(name, path)
    end
  end

  def admin_prev_issue_link
    prev_issue = @issue.prev
    if prev_issue == nil
      ''
    else
     link_to('Pick the Previous Issue', new_issue_article_path(:issue_id => d(prev_issue.date)))
    end
  end

  def admin_next_issue_link
    next_issue = @issue.next
    if next_issue == nil
      ''
    else
     link_to('Pick the Next Issue', new_issue_article_path(:issue_id => d(next_issue.date)))
    end
  end

  def is_update?
    if @article.priority < 1
      #news update
      return true
    elsif @article.posted_at.nil?
      #old data
      return false
    elsif @article.posted_at > (@article.issue.date + 12.hours)
      return true
    else
      return false
    end
  end

  #Find the next article priority for an issue
  def next_article_priority
    #debugger
    last_art = Article.find(:first, :conditions => ['issue_id = ?', @issue.id], :order => 'priority DESC')
    if last_art.nil?
      1
    else
      last_art.priority + 1
    end
  end

  #MHO Interesting idiom.  Render partial or whatever for left menu but only if helper exists.
  def left_menu
    #debugger
    menu_method_name = "#{self.controller_name}_left_menu".to_sym
    if respond_to?(menu_method_name)
      send(menu_method_name)
    end
  end

  def right_menu
    #debugger
    menu_method_name = "#{self.controller_name}_right_menu".to_sym
    if respond_to?(menu_method_name)
      send(menu_method_name)
    end
  end

  def nilp(object, method)
    if object.nil?
      return ''
    else
      return object.send(method)
    end
  end

  # URL-encode a string -- BDP Special wersion " " to "%20".
  #   url_encoded_string = bdp_escape("'Stop!' said Fred")
  #      # => "%27Stop%21%27%20said%20Fred"
  def bdp_escape(string)
    string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.gsub(/ /, "%20") #MHO .tr(' ', '+')
  end
  
  def cat_text(priority)
    if priority < -200
      "Not Visible"
    elsif priority <= 0
      "Extra"
    elsif priority < 6
      "Page One"
    elsif priority == 6
      "Editorials"
    elsif priority <= 19
      "Features"
    elsif priority <= 24
      "Election Section"
    elsif priority <= 29
      "Press Releases"
    elsif priority <= 39
      "Columns"
    elsif priority <= 49
      "Comments"
    elsif priority <= 54
      "Arts Listings"
    elsif priority <= 59
      "Arts &amp; Events"
    elsif priority <= 64
      "Home &amp; Garden Columns"
    elsif priority <= 69
      "Home &amp; Garden"
    elsif priority <= 74
      "Events Listings"
    elsif priority <= 79
      "Events"
    elsif priority <= 84
      "Cartoons"
    elsif priority <= 89
      "The Editor's Back Fence"
    elsif priority <= 92
      "Obituaries"
    else
      "Not Visible"
    end
  end
  
  def g_keywords(priority)
    if priority == 6
      "Editorial"
    elsif priority > -200 && priority < 29
      "local, berkeley, california, east bay, news"
    elsif priority <= 49
      "Politics"
    elsif priority <= 54
      "Arts Calendar"
    elsif priority <= 59
      "Arts and Events"
    elsif priority <= 69
      "Home and Gardens"
    elsif priority <= 74
      "Events Calendar"
    elsif priority <= 79
      "Events"
    elsif priority <= 89
      "Politics"
    elsif priority <= 92
      "Obituary"
    else
      ""
    end
  end

  def title
    if @issue.nil?
      'The Berkeley Daily Planet'
    else
      'The Berkeley Daily Planet' # - #{@issue.date.strftime('%A %B %d, %Y')}
    end
  end

  ##Various Photo/image helpers
    
  def photo_exists(image)
    #debugger
    file = Rails.root.join('public', "photos/#{image.issue.date.strftime('%m-%d-%y')}/#{image.file_name}")
    File.exists?(file)
  end

  def all_photo_files(issue)
    #debugger
    dir = Rails.root.join('public', "photos/#{issue.date.strftime('%m-%d-%y')}")
    p = Pathname(dir)
    if File.exists?(p)
      p.children
    else
      false
    end
  end

  def show_photo_file(issue, file_name, html_options = {})
    #debugger
    html_options[:alt] ="/photos/#{issue.date.strftime('%m-%d-%y')}/#{bdp_escape("#{file_name}")}"
    tag('img', html_options)
  end
 
  #Show the first photo of an article (as a thumb) (Unless it is also the fpi)
  def article_photo(article)
    unless article.images.empty?
      if @issue.front_page_image.nil?
        fpi = ''
      else
        fpi = @issue.front_page_image.file_name
      end
      unless article.images.first.file_name == fpi
        if photo_exists(article.images.first)
          #class photox for thumbs
          content_tag('div', link_to(photo_img(article.images.first), "###{article.id}")) #No class, :class => 'photox')
        end
      end
    end
  end

  #Show all photos for an article (in full size)
  def article_photos(article)
    result = ''
    for image in article.images
      result << photo_with_caption(image, 'artphoto')
    end
    unless result == ''
      result = raw content_tag('div', raw(result), :class => :photos)
    end
    #debugger
    result
  end

  def front_page_photo
    #photo_with_caption(@issue.last_front_page_image,'photo')
    #debugger
    photo_with_caption(@issue.front_page_image,'photo')
  end
  
  def photo_img(image, html_options = {})
    #debugger
    if image.nil?
      return ''
    end
    html_options[:alt] = html_options[:alt] || image.caption ##MHO Caption messes up picture but is good for Google
    html_options[:src] = "/photos/#{image.issue.date.strftime('%m-%d-%y')}/#{bdp_escape(image.file_name)}"
    #debugger
    tag('img', html_options)
  end

  def photo_with_caption(image, div_class = :photo, html_options = {})
    #debugger
    result = ''
    unless image.nil?
      if photo_exists(image)
        if image.article_id.nil?
          result << link_to(photo_img(image, html_options), '##top')
        else  #MHO work in progress
          result << link_to(photo_img(image, html_options), "###{image.article_id}")
        end
        #debugger
        unless image.author.nil?
          result << "\n" << content_tag('div', image.author, :class => 'photographer')
          #result << "\n <br clear='right'/>"
        end
        #debugger
        unless image.caption.nil?
          result << "\n" << content_tag('div', image.caption, :class => 'caption')
        end
      end
    end
    unless result == ''
      result = raw content_tag('div', raw(result), :class => div_class)
    end
    #debugger
    result
  end
end
