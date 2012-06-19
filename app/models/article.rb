class Article < ActiveRecord::Base
  belongs_to :issue
  has_many :images

  #No article w/o an issue
  validates_presence_of :issue

  #Return 1st paragraph
  def preview
    if copy.nil?
      return ''
    end

    end_of_para = copy.index("\r\n")

    if end_of_para.nil?
      copy
    else
      copy[0..end_of_para]
    end
  end

  def in_new_section?
    section == 'New'
  end

  def in_flash_section?
    section == 'News Flash'
  end
  
  def in_updated_section?
    section == 'Updated'
  end

  def in_press_section?
    section == 'Press Release'
  end

  def self.full_feed_articles(delay)
    #debugger
    @issue = PubDate.latest
    iss = @issue.date - 7
    find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date >= ?  AND posted_at >= ?',
      iss, Time.now - delay.days], :order => 'posted_at DESC')   
  end
  
  def self.all_editorials
    iss = Date.strptime('2003-04-01', '%Y-%m-%d')
    @issue = PubDate.latest
    #debugger
    find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND (priority = 6 OR (priority >= 85 AND priority < 90))', iss], :order => 'issues.date DESC')
  end
  
  

end
