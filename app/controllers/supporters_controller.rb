class SupportersController < ApplicationController
  
  #All controllers are secure except the ones that are specifically marked as not secure
  def secure?
    #debugger
    true
  end

  # GET /supporter
  # GET /supporter.xml
  def index
    @supporters = Supporter.paginate(:all, :page => params[:page], :order => 'last_name') #find(:all)
    @issue = PubDate.latest

    respond_to do |format|
      format.html { render :layout => 'public' } # index.html.erb
      format.xml  { render :xml => @supporter }
    end
  end

  # GET /supporter/1
  # GET /supporter/1.xml
  def show
    @supporter = Supporter.find(params[:id])
    @issue = PubDate.latest

    respond_to do |format|
      format.html { render :layout => 'public' } # show.html.erb
      format.xml  { render :xml => @supporter }
    end
  end

  # GET /supporter/new
  # GET /supporter/new.xml
  def new
    @supporter = Supporter.new
    @issue = PubDate.latest

    respond_to do |format|
      format.html { render :layout => 'public' } # new.html.erb
      format.xml  { render :xml => @supporter }
    end
  end

  def thanks
    @issue = PubDate.latest
    render :layout => 'public'
  end

  # GET /supporter/1/edit
  def edit
    @supporter = Supporter.find(params[:id])
    @issue = PubDate.latest
    render :layout => 'public'
  end

  # POST /supporter
  # POST /supporter.xml
  def create
    @supporter = Supporter.new(params[:supporter])
    respond_to do |format|
      if @supporter.save
        flash[:notice] = 'Supporter was successfully created.'
        if user.nil?
          format.html { redirect_to(:action => 'thanks') }
        else 
          format.html { redirect_to(:action => 'index') } 
        end
        format.xml  { render :xml => @supporter, :status => :created, :location => @supporter }
      else
        flash[:notice] = 'Creation Error.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @supporter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /supporter/1
  # PUT /supporter/1.xml
  def update
    @supporter = Supporter.find(params[:id])
    respond_to do |format|
      if @supporter.update_attributes(params[:supporter])
        flash[:notice] = 'Supporter was successfully updated.'
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supporter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /supporter/1
  # DELETE /supporter/1.xml
  def destroy
    @supporter = Supporter.find(params[:id])
    @supporter.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index') }
      format.xml  { head :ok }
    end
  end

protected
  def secure?
    if ['create', 'new', 'thanks'].include?(action_name)
      false
    else
      true
    end
  end
end
