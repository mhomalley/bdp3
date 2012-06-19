class ImagesController < ApplicationController

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
      if params[:issue_id] == 'latest'
        @issue = Issue.find(:first, :order => 'date DESC')
        params[:issue_id] = d(@issue.date)
      else
        @issue = Issue.find_by_strdate(params[:issue_id])
      end
    # old why? fixit? else
    #  @issue = Issue.find(:first, :order => 'date DESC')
    end
    #@articles = @issue.articles.find(:all, :order => 'priority')
  end

  # GET /images
  # GET /images.xml
  #MHO index only for articles
  def xx_index #MHO Work on this
    #debugger
    if params.has_key?(:article_id) #not @article.nil?
      @article = Article.find(params[:article_id])
      @images = @article.images
    else
      @image = @issue.front_page_image
    end
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @images.to_xml }
    end
  end

  # GET /images/1
  # GET /images/1.xml
  #MHO Following actions are polymorphic between issue and article!
  def show
    #debugger
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @image.to_xml }
    end
  end

  # GET /images/new
  def new
    #debugger
    @image = Image.new
    #if params.has_key?(:article_id)
    #  @article = Article.find(params[:article_id]) #MHO Never happens
    #  @image.article = @article
    #end
  end

  # GET /images/1;edit
  def edit
    #debugger
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.xml
  def create
    #debugger
    #MHO check for blank file_name
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

      #unless @article.nil?
      #  @image.article = @article #MHO Never happens
      #end

    respond_to do |format|
      #debugger
      if @image.save
        #if @article.nil?
        @issue.front_page_image = @image #MHO Always happens
        @issue.save!
        #end
        format.html { redirect_to new_issue_article_path(:issue_id => d(@issue.date)) }
        flash[:notice] = 'Image was successfully created.'
        format.xml  { head :created, :location => image_path(@image) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @image.errors.to_xml }
      end
    end
    end
  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
    #debugger
    @image = Image.find(params[:id])
    #MHO Ever not fpi?
    if params[:fpi] == '1'
      #MHO Add fpi here
      @issue.front_page_image = @image
      @issue.save!
    end

    respond_to do |format|
      if @image.update_attributes(params[:image])
        flash[:notice] = 'Image was successfully updated.'
        format.html { redirect_to new_issue_article_path(:issue_id => d(@issue.date)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors.to_xml }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    #debugger
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html {redirect_to new_issue_article_path(:issue_id => d(@issue.date))}
      format.xml  { head :ok }
    end
  end
end
