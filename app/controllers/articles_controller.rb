class ArticlesController < ApplicationController

  layout 'admin'

  before_filter :find_issue
  
  #All controllers are secure except the ones that are specifically marked as not secure
  def secure?
    #debugger
    true
  end

  def find_issue
    #debugger
    if params.has_key?(:issue_id)
      if params[:issue_id] =~ /20\d\d-[01]?\d-\d\d/
        @issue = Issue.find_by_strdate(params[:issue_id])
      else
        @issue = Issue.find(params[:issue_id])
      end
    else
      @issue = Issue.find(:first, :order => 'date DESC')
    end
  end

  # GET /articles
  # GET /articles.xml
  def index
    debugger
    @articles = @issue.articles.find(:all, :order => 'priority') if @issue
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @articles.to_xml }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    debugger
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @article.to_xml }
    end
  end

  #these shouldn't be here!
  def bdp_to_html
    @article.headline.gsub!(/\s+/m, " ")
    @article.headline.gsub!(/^\s*(.*)\s*$/, '\1')
    
    @article.author.gsub!(/\s+/m, " ")
    @article.author.gsub!(/^\s*(.*)\s*$/, '\1')
    
    @article.copy.sub!(/^[ \t]*/, "<p>\t")
    @article.copy.gsub!(/\r\n[ \t]*/m, "<\/p>\r\n<p>\t")
    @article.copy.sub!(/\z/m, "<\/p>")
  end
  
  def html_to_bdp  #Fixed p vs param html bug -- also, retained span
    @article.copy.gsub!(/\&nbsp;/, " ")    #Don't see a reason for &nbsp;
    
    @article.copy.gsub!(/\&lt;/, "<")
    @article.copy.gsub!(/\&gt;/, ">")     #Editor doesn't like hand coded HTML

    @article.copy.gsub!(/\r?\n[ \t\r]*\n/m, "<\/p>") # Blank line == paragraph
    #@article.copy.gsub!(/\r?\n *\t */m, "<\/p>")     # \t with optional spaces == paragraph
    
    @article.copy.gsub!(/\r?\n/m, " ")    # Now remove all \n
    
    @article.copy.gsub!(/<p>/, " ")
    @article.copy.gsub!(/<p [^>]*?>/, " ") # Remove fancy paragraphs -- What about fancy spans?
    #@article.copy.gsub!(/<span[^>]*?>/, " ") # Remove fancy spans
    #@article.copy.gsub!(/<\/span[^>]*?>/, " ") # Remove fancy spans

    @article.copy.gsub!(/<\/p>/, "\r\n")  # </p> is true \n
    @article.copy.gsub!(/^[ \t]+/, "")    # Remove Para initial white space
    
    @article.copy.sub!(/\r\n\z/, "")      # Remove the final \n
  end


  # GET /articles/new
  def new
    #debugger
    @article = Article.new
    @article.issue = @issue
    @image = Image.new
  end

  # GET /articles/1;edit
  def edit
    #debugger
    @article = Article.find(params[:id])
    bdp_to_html()    #make the @article look more like HTML
    @image = Image.new  #When editing an article, get a new image.
  end

  # POST /articles
  # POST /articles.xml
  def create
    debugger
    @article = @issue.articles.build(params[:article])
    html_to_bdp()    #make the @article look more like the BDP standard

    params[:image] = nil if params[:image][:file_name] == ''

    unless params[:image] == nil
      fs_file_path = image_fs_path(@issue, params[:image][:file_name].original_filename())
      File.open(fs_file_path, 'wb') do |f|
        f.write(params[:image][:file_name].read)
      end
      file_name = params[:image][:file_name].original_filename()
      params[:image].delete(:file_name)
      @image = Image.new(params[:image])
      @image.file_name = file_name
    end

    @image.article = @article unless params[:image] == nil
    @article.save!
    @image.save! unless params[:image] == nil
    #debugger
    if params[:fpi] == '1'
      #MHO Add fpi here
      @issue.front_page_image = @image
      @issue.save!
    end
    flash[:notice] = 'Article was successfully created.'
    redirect_to new_issue_article_path(:issue_id => d(@issue.date))

  rescue ActiveRecord::RecordInvalid => e
    @image.valid? unless params[:image] == nil
    render :action => :new

  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    #debugger
    @article = Article.find(params[:id])

    params[:image] = nil if params[:image][:file_name] == nil #''

    unless params[:image] == nil
      fs_file_path = image_fs_path(@issue, params[:image][:file_name].original_filename())
      File.open(fs_file_path, 'wb') do |f|
        f.write(params[:image][:file_name].read)
      end
      file_name = params[:image][:file_name].original_filename()
      params[:image].delete(:file_name)
      @image = Image.new(params[:image])
      @image.file_name = file_name
    end

    Article.transaction do
      @image.article = @article unless params[:image] == nil
      if @article.update_attributes(params[:article])
        html_to_bdp()    #make the @article look more like the BDP standard
        @article.save!
        flash[:notice] = 'Article was successfully updated.'
      end
      @image.save! unless params[:image] == nil
      #debugger
      if params[:fpi] == '1'
        #MHO Add fpi here
        @issue.front_page_image = @image
        @issue.save!
      end
      redirect_to new_issue_article_path(:issue_id => d(@issue.date))
    end

  rescue ActiveRecord::RecordInvalid => e
    @image.valid? unless params[:image] == nil
    render :action => :edit
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    #debugger
    @article = Article.find(params[:id])
    @issue = @article.issue
    @article.destroy

    respond_to do |format|
      format.html { redirect_to new_issue_article_path(:issue_id => d(@issue.date)) }
      format.xml  { head :ok }
    end
  end
end
