class PublicController < ApplicationController

  caches_page :index, :article, :archives, :contact, :opinion, :arts_entertainment, :columns, :summary, :news #, :full_text

  # fixit?? session :off

  before_filter :find_issue

  #No password for any method in this controller
  def secure?
    #debugger
    false
  end

  #Make sure that @issue is valid
  #  and :storyID exists
  def find_issue
    #debugger
    if params.has_key?(:storyID)
      @article = Article.find(params[:storyID])
      @issue = @article.issue
    elsif params.has_key?(:issue_id)
      @issue = Issue.find_by_strdate(params[:issue_id])
    elsif params.has_key?(:issue)
      @issue = Issue.find_by_strdate_short(params[:issue])
    elsif params.has_key?(:archiveDate)
      @issue = Issue.find_by_strdate_short(params[:archiveDate])
    end

    unless @issue
      #Currently only short or missing date or crap Following change(5/10) should have no effect but should
      #be made in other controllers
      @issue = PubDate.latest  #Issue.find(:first, :order => 'date DESC')
    end 
  rescue
    debugger
    flash.now[:notice] = "No such Issue or Article."
    render(:action => 'unknown', :layout => "admin", :status => '404')
    #cur_issue
  end

  #Get to the latest issue
  def cur_issue
    #debugger
    @issue = PubDate.latest
    redirect_to public_issue_url(:issue_id => d(@issue.date) )
  rescue
    flash.now[:notice] = "No Latest Issue."
    render(:action => 'unknown', :layout => "admin", :status => '404')
  end
    
  def index
    #debugger
  end

  def openletter
    render :layout => "general"
  end
  
  def fund
    render :layout => "general"
  end
  
  #def benefit
  #  render :layout => "general"
  #end
  
  def summaryX
    render :layout => "general"
  end

  def full_textX
    respond_to do |format|
      format.html { render :layout => 'general' }
      format.xml
    end
  end
  
  #if :storyID is set, go to the article else go to the current issue.
  def article
    #debugger
    unless params.has_key?(:storyID)
      flash.now[:notice] = "No such Article."
      render(:action => 'unknown', :layout => "admin", :status => '404')
    end
  end

  def archives
    #debugger
    @dates = Issue.get_dates
    @year_dates = @dates.group_by {|date| date.strftime('%y')}
    
    if params.has_key?(:yr)
      @yr = params[:yr]
    else 
      @yr = @issue.date.strftime('%y')
    end
    
    if params.has_key?(:mo)
      @mo = params[:mo]
    elsif params.has_key?(:yr)
      #@mo = maxmonth for that year
      @mo = @year_dates[@yr].collect {|date| date.strftime('%m')}.max
    else
      @mo = @issue.date.strftime('%m')
    end

    @years = @dates.collect {|date| date.strftime('%y')}.uniq.sort
    @months = @year_dates[@yr].collect {|date| date.strftime('%m')}.uniq.sort
    @days = @year_dates[@yr].group_by {|date| date.strftime('%m')}[@mo].sort
    render :layout => "general"
  end

  #Bad or unsupported URL given.  Try to find an article or issue
  def unknown
    #debugger
    if params.has_key?(:storyID)
      redirect_to public_article_url(:issue_id => d(@issue.date), :storyID => @article, :host => 'www.berkeleydailyplanet.com', :status => '301')
    elsif params.has_key?(:issue) || params.has_key?(:archiveDate)
      redirect_to public_issue_url(:issue_id => d(@issue.date), :host => 'www.berkeleydailyplanet.com', :status => '301' )
    else
      flash.now[:notice] = "Unrecognized URL"
      render :layout => "general", :status => '404'
    end
  rescue
    #flash.now[:notice] = "No such Issue or Article."
    flash.now[:notice] = "Unrecognized URL2"
    render :layout => "general", :status => '404'
  end
end
