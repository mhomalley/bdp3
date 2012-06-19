class PhotosController < ApplicationController

  layout 'admin'

  before_filter :find_issue

  before_filter :find_photos
  
  def find_issue
    debugger
    if params.has_key?(:issue_id)
      if params[:issue_id] == 'latest'
        @issue = Issue.find(:first, :order => 'date DESC')
        params[:issue_id] = d(@issue.date)
      else
        @issue = Issue.find_by_strdate(params[:issue_id])
      end
    end
    #@articles = @issue.articles.find(:all, :order => 'priority')
  end

  def find_photos
    #debugger
  end

  # GET /photos
  # GET /photos.xml
  def index
    @photos = Photo.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photos.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo.to_xml }
    end
  end

  # GET /photos/new
  def new
   debugger
   @photo = Photo.new
  end

  # GET /photos/1;edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    debugger
    fs_file_path = image_fs_path(@issue, params[:photo][:name].original_filename())
    File.open(fs_file_path, 'wb') do |f|
      f.write(params[:photo][:name].read)
    end
    file_name = params[:photo][:name].original_filename()
    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :created, :location => photo_url(@photo) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.xml  { head :ok }
    end
  end
end
