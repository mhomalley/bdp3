class Issue < ActiveRecord::Base
  has_many :articles, :order => 'priority'
  belongs_to :front_page_image, :class_name => 'Image', :foreign_key => 'front_page_image'

  #Specific article classes for an issue can be added here
  has_many :other_news_articles, :class_name => 'Article', :conditions => ['priority > 0 AND priority < 30 AND priority != 6'], :order => 'priority'
  has_many :feature_articles, :class_name => 'Article', :conditions => ['priority >= 50'], :order => 'priority'

  validates_uniqueness_of :date

  #Get an array of all issue dates
  def self.get_dates
    find(:all, :order => 'date DESC').collect {|issue| issue.date }
  end

  #Note find_by_strdate finds first date <= date while find_by_strdate_short is exact
  def self.find_by_strdate(str_date)
    #find_by_date(Date.strptime(str_date, '%Y-%m-%d'), :order => 'date DESC')
    #debugger
    find(:first, :conditions => ['date <= ?', Date.strptime(str_date, '%Y-%m-%d')], :order => 'date DESC')
  end

  def self.find_by_strdate_short(str_date)
    find_by_date(Date.strptime(str_date, '%m-%d-%y'))
  end

  #Find the next issue
  def next
    Issue.find(:first, :conditions => ['date > ?', date], :order => 'date')
  end

  #Find the previous issue
  def prev
    Issue.find(:first, :conditions => ['date < ?', date], :order => 'date DESC')
  end
  
  #Find the last front_page_image
  def last_front_page_image
    Issue.find(:first, :conditions => ['date <= ? AND front_page_image', date], :order => 'date DESC').front_page_image
  end
  
  def self.latest
    Issue.find(:first, :order => 'date DESC')
  end

  #find one or more articles not necessarily confined to the particular issue.


  #def all_recent
  #  iss = Issue.find_by_id(id).date
  #  #debugger
  #  Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
  #    :conditions => ['issues.date > ? AND issues.date <= ? AND priority > -200',
  #    iss - 7, iss], :order => 'issues.date DESC, priority')
  #end

  def breaking_news_articles
    Article.find(:all, :conditions => ['issue_id = ? AND (priority <= 0 AND priority > -200)', id], :order => 'priority')
  end

  def top_news_articles
    Article.find(:all, :conditions => ['issue_id = ? AND (priority > 0 AND priority <= 5)', id], :order => 'priority')
  end

  def more_news_articles
    Article.find(:all, :conditions => ['issue_id = ? AND (priority > 6 AND priority < 20)', id], :order => 'priority')
  end

  def election_news_articles
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 20 AND priority < 25)', id], :order => 'priority')
  end

  def pr_news_articles
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 25 AND priority < 30)', id], :order => 'priority')
  end
  
  def news_recent
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND issues.date <= ? AND ((priority > -200 AND priority < 30 AND priority != 6) OR priority >= 90)',
      iss - 7, iss], :order => 'issues.date DESC, priority')
  end

  def cur_editorials
    Article.find(:all, :conditions => ['issue_id = ? AND priority = 6', id], :order => 'priority')
  end

  def cur_editorials_recent
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND issues.date <= ? AND priority = 6',
      iss - 7, iss], :order => 'issues.date DESC, priority')
  end
  
  #Find the last editorial
  def last_editorial
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:first, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date <= ? AND priority = 6', iss], :order => 'issues.date DESC, priority')
  end
  
  def new_editorials
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 85 AND priority < 90)', id], :order => 'priority')
  end

  def new_editorials_recent
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND issues.date <= ? AND priority >= 85 AND priority < 90',
      iss - 7, iss], :order => 'issues.date DESC, priority')
  end
  
  def ed_cartoons
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 80 AND priority < 85)', id], :order => 'priority')
  end

  def ed_cartoons_recent
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND issues.date <= ? AND priority >= 80 AND priority < 85',
      iss - 7, iss], :order => 'issues.date DESC, priority')
  end
  
  #def cur_letters_to_the_editor
  #  Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 40 AND priority < 45)', id], :order => 'priority')
  #end

  def opinion_articles  # Added letters
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 40 AND priority < 50)', id], :order => 'priority')
  end

  def commentary_recent
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND issues.date <= ? AND priority >= 40 AND priority < 50',
      iss - 7, iss], :order => 'issues.date DESC, priority')
  end
  
  def columnists_articles
    Article.find(:all, :conditions => ['issue_id = ? AND ((priority >= 30 AND priority < 40) OR (priority >= 60 AND priority <= 65))', id], :order => 'priority')
  end

  def columnists_recent   #added 65-69
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND issues.date <= ? AND ((priority >= 30 AND priority < 40) OR (priority >= 60 AND priority < 70))',
      iss - 7, iss], :order => 'issues.date DESC, priority')
  end
  
  def home_garden_only
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 66 AND priority < 70)', id], :order => 'priority')
  end
  
  #removed arts calendar #
  def arts_articles
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 55 AND priority < 60)', id], :order => 'priority')
  end

  def obit_articles
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 90 AND priority < 92)', id], :order => 'priority')
  end

  #Used for all "events"
  def cur_calendars
    Article.find(:all, :conditions => ['issue_id = ? AND ((priority >= 50 AND priority < 55) OR (priority >= 70 AND priority < 75))', id], :order => 'priority')
  end

  def arts_calendars
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 50 AND priority < 55)', id], :order => 'priority')
  end

  def events_calendars
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 70 AND priority < 75)', id], :order => 'priority')
  end

  def events
    Article.find(:all, :conditions => ['issue_id = ? AND (priority >= 75 AND priority < 79)', id], :order => 'priority')
  end

  def arts_entertainment_recent  # 9/11 includes home and events
    iss = Issue.find_by_id(id).date
    #debugger
    Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
      :conditions => ['issues.date > ? AND issues.date <= ? AND priority >= 50 AND priority < 80',
      iss - 7, iss], :order => 'issues.date DESC, priority')
  end
  
  #following are all multi-issue  
  #def editorials  #Not currently used
  #  iss = Issue.find_by_id(id).date
  #  #debugger
  #  Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
  #    :conditions => ['issues.date > ? AND issues.date <= ? AND (priority = 6 OR (priority >= 85 AND priority < 90))', iss - 7, iss], :order => 'issues.date DESC')
  #end
  
  #def home_garden
  #  iss = Issue.find_by_id(id).date
  #  #debugger
  #  Article.find(:all, :joins => 'inner join issues on articles.issue_id = issues.id',
  #    :conditions => ['issues.date > ? AND issues.date <= ? AND priority >= 60 AND priority < 70',
  #    iss - 7, iss], :order => 'issues.date DESC, priority')
  #end
  
end
