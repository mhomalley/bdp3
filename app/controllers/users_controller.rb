class UsersController < ApplicationController

  layout 'admin'

  def secure?
    #debugger
    if (action_name == 'login')
      false
    else
      true
    end
  end
  hide_action :secure?

  # GET /admin/users
  # GET /admin/users.xml
  def index
    #debugger
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  #MHOdef show
  #  @user = User.find(params[:id])
  #  respond_to do |format|
  #    format.html # show.rhtml
  #    format.xml  { render :xml => @user.to_xml }
  #  end
  #end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit #MHO REady for Rails 2
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    #debugger
    if params[:user][:password].strip != params[:confirm_password].strip
      @user = User.new(params[:user])
      respond_to do |format|
        flash[:error] = "The passwords do not match"
        format.html { render :action => 'edit' }
      end
    else
      @user = User.new(params[:user])
      respond_to do |format|
        if @user.save
          flash[:notice] = 'User was successfully created.'
          format.html { redirect_to users_path }
        else
          flash[:notice] = 'Problem with creating User.'
          format.html { render :action => "new" }
        end
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    #debugger
    if params[:user][:password].strip != params[:confirm_password].strip
      @user = User.find(params[:id])
      respond_to do |format|
        flash[:error] = "The passwords do not match"
        format.html { render :action => 'edit' }
      end
    else
      @user = User.find(params[:id])
      respond_to do |format|
        if @user.update_attributes(params[:user])
          flash[:notice] = 'User was successfully updated.'
          format.html { redirect_to users_path }
        else
          flash[:notice] = 'Problem with updating User.'
          format.html { render :action => "edit" }
        end
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User deleted.'

    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  def logout
    #debugger
    session['user_name'] = nil
    redirect_to(login_users_path)
  end

  def login
    #debugger
    session['user_name'] = nil
  end

  def do_login
    #debugger
    redirect_to(admin_path)
  end
end
